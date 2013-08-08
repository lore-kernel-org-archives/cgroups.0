From: Ma Shimiao <shimiao.ma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] tfix
Date: Thu,  8 Aug 2013 23:29:29 +0800
Message-ID: <1375975769-1764-1-git-send-email-shimiao.ma@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=1e57tLAD/8S2KK+ZvelZOEwm7ViekxOyNfhxnZr53Ko=;
        b=sFDX73FI10DLFWAvGQfx+VAHPDywOWNyRvadrcl5jz3St39w7IhnhXp35n9TEABBt4
         K3/2h3R4piPeBuJY4OgPl7SQdb7yMPeOvyZVcgHao4bIzVhY9LVIby0TMAlvYcwJCUoW
         WZopuzJTU7J2Ezat61Pcr9yVrthgRhi+HAnVxpJ91fa1HZHCZa7yyPmNPQQKabfIZbGh
         w7CpVg4liN8M0nb5rvBFMv3H25SlaofR6D9ImTqn7Lk+Tb27uBgv6839plSD/+1NYKT7
         dJnwWbKn01yQf5Jp/u5y3eQPMaljNkWygDhL9F2lq6oEYsU0JZd7XTqBLBg1MvozdBm/
         YIkA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ma Shimiao <shimiao.ma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ma Shimiao <shimiao.ma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/cgroup/cgroup_event_listener.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgroup_event_listener.c
index 4eb5507..b46d6eb 100644
--- a/tools/cgroup/cgroup_event_listener.c
+++ b/tools/cgroup/cgroup_event_listener.c
@@ -37,7 +37,7 @@ int main(int argc, char **argv)
 	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
 			dirname(argv[1]));
 	if (ret >= PATH_MAX)
-		errx(1, "Path to cgroup.event_control is too long");
+		errx(1, "Path to cgroup.event_control string is too long");

 	event_control = open(event_control_path, O_WRONLY);
 	if (event_control == -1)
@@ -68,7 +68,7 @@ int main(int argc, char **argv)

 		ret = access(event_control_path, W_OK);
 		if ((ret == -1) && (errno == ENOENT)) {
-			puts("The cgroup seems to have removed.");
+			puts("The cgroup seems to have been removed.");
 			break;
 		}

--
1.8.3.1
