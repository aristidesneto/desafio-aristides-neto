from flask import Flask, jsonify, request
from comments_api.logger import logger

app = Flask(__name__)

comments = {}

@app.after_request
def after_request(response):
    logger.info('%s %s %s %s %s',
        request.remote_addr,
        request.method,
        request.scheme,
        request.full_path,
        response.status)
    
    return response

@app.route('/api/comment/new', methods=['POST'])
def api_comment_new():
    request_data = request.get_json()

    email = request_data['email']
    comment = request_data['comment']
    content_id = '{}'.format(request_data['content_id'])

    new_comment = {
            'email': email,
            'comment': comment,
            }

    if content_id in comments:
        comments[content_id].append(new_comment)
    else:
        comments[content_id] = [new_comment]

    message = 'comment created and associated with content_id {}'.format(content_id)
    logger.info(message)
    response = {
            'status': 'SUCCESS',
            'message': message,
            }
    return jsonify(response)


@app.route('/api/comment/list/<content_id>')
def api_comment_list(content_id):
    content_id = '{}'.format(content_id)

    if content_id in comments:
        return jsonify(comments[content_id])
    else:
        message = 'content_id {} not found'.format(content_id)
        logger.info(message)
        response = {
                'status': 'NOT-FOUND',
                'message': message,
                }
        return jsonify(response), 404


if __name__ == '__main__':
    app.run()