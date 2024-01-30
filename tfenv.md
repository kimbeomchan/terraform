# tfenv
# 테라폼 버전관리를 위한 tfenv 도구에 대한 설명입니다.

# git clone 후 path 환경변수 추가
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile

# 실행 파일에 대한 Symlink 생성
sudo ln -s ~/.tfenv/bin/* /usr/local/bin

# 버전 확인
tfenv --version

# 테라폼 버전 목록 확인
tfenv list-remote

# 특정 버전 설치
tfenv install 1.3.4

# 설치된 테라폼 버전 목록 확인
tfenv list

# 특정 버전 사용
tfenv use 1.3.4

# * 참고
# 테라폼 버전 변경이 번거로운 경우, ".terraform-version"을 사용
# ".terraform-version"에 명시한 버전은 해당 디렉토리 및 하위 디렉토리에 해당 버전으로 적용됨
# 자세한 설명: https://github.com/tfutils/tfenv#terraform-version