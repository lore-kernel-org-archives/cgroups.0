From: Dmitry Yakunin <zeil@yandex-team.ru>
Subject: [PATCH net-next 0/2] inet_diag: add cgroup attribute and filter
Date: Thu, 30 Apr 2020 18:51:13 +0300
Message-ID: <20200430155115.83306-1-zeil@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588261899; bh=Ku8M8hsNgp8O42QWYAa8JWNrA46x0d2sORiVmI0TciA=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=SNX33+CpmExEVsZns5imat3HdhckqaXSC6iG/J79Z2CPidsWhPrMXZlVBmZPr0tmi
         cbaNs3mNs4LBHCeHqDw1y5l46E33Y4GLhecXvVb8ewx+omfkOHuWnDgHLL/U0f3qMz
         PnczXtC3Alr9vj5AG/U6mg/Xigu0qQbYqp9v5PhE=
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, tj@kernel.org, cgroups@vger.kernel.org, bpf@vger.kernel.org

This patch series extends inet diag with cgroup v2 ID attribute and
filter. Which allows investigate sockets on per cgroup basis. Patch for
ss is already sent to iproute2-next mailing list.

Dmitry Yakunin (2):
  inet_diag: add cgroup id attribute
  inet_diag: add support for cgroup filter

 include/linux/inet_diag.h      |  6 +++++-
 include/uapi/linux/inet_diag.h |  2 ++
 net/ipv4/inet_diag.c           | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

-- 
2.7.4

