ARG image=ubuntu:rolling

FROM $image AS build

ENV userName app
ENV groupName $userName
ENV userId 1000
ENV groupId $userId
ENV userHome /$userName

WORKDIR /build
ADD userBin/* $userHome/userBin/
ADD bin/build.bash /bin
RUN bash /bin/build.bash

FROM $image

ENV userName app
ENV groupName $userName
ENV userId 1000
ENV groupId $userId
ENV userHome /$userName

WORKDIR $userHome

COPY --from=build /build/tini/tini-static /bin/tini
COPY --from=build /bin/hyperfine /bin/hyperfine
COPY --from=build /bin/smileypyramid /bin/smileypyramid
ADD *.bash /bin
RUN bash /bin/init.bash
ENTRYPOINT ["/bin/tini", "--", "/bin/bash", "-o", "errexit", "-o", "pipefail", "-o", "xtrace", "/bin/entrypoint.bash"]