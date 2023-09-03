From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 2/5] bpf: Enable cgroup_array map on cgroup1
Date: Sun,  3 Sep 2023 14:27:57 +0000
Message-ID: <20230903142800.3870-3-laoar.shao@gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693751291; x=1694356091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jjy5F3GLFbzbY5Veg10sJXncHFcZhNqzR3hA1fgbxTA=;
        b=cdFTQqqsDTeRINqpsMTKC2OPmXg59qKykpNyvZwX4LhU46NrFvBlbPJQo11Cgfh4TR
         XD1jUwLVvPWd9rMvKvaLPYAfxdPD9Diea3P9MZTl72+Ma5ODcubogdVO7OBzZkp2rG2H
         Z7BS0be/KQ5Z79XfKnyJ9BcpJlUvIkkOVryMqCln1/bNbDD/UKbw/Eq/d/zNefmmDjvZ
         ZP5LjUU2vM7eVeOsvJNgTsodKZc7toTwdiyl6RdyOkPYCIF7Ld3zRY+4UQCPXlXKsYsM
         OzPc2zI9Wbw7uxK4dOjo7wHyQsQhN8mqnY9geYjSZxwU3iKNGE0L1VespYXF03zpR901
         15cw==
In-Reply-To: <20230903142800.3870-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The cgroup_array map currently has support exclusively for cgroup2, owing
to the fact that cgroup_get_from_fd() is only valid for cgroup2 file
descriptors. However, an alternative approach is available where we can use
cgroup_v1v2_get_from_fd() for both cgroup1 and cgroup2 file descriptors.

The corresponding cgroup pointer extracted from the cgroup file descriptor
will be utilized by functions like bpf_current_task_under_cgroup() or
bpf_skb_under_cgroup() to determine whether a task or socket buffer (skb)
is associated with a specific cgroup. In a previous commit, we successfully
enabled bpf_current_task_under_cgroup(), ensuring the safety of storing a
cgroup1 pointer within the cgroup_array map.

Regarding bpf_skb_under_cgroup(), it is currently restricted to cgroup2
functionality only. Nevertheless, it remains safe to verify a cgroup1
pointer within this context as well, with the understanding that it will
return a "false" result in such cases.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/bpf/arraymap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 2058e89..30ea57c 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1291,7 +1291,7 @@ static void *cgroup_fd_array_get_ptr(struct bpf_map *map,
 				     struct file *map_file /* not used */,
 				     int fd)
 {
-	return cgroup_get_from_fd(fd);
+	return cgroup_v1v2_get_from_fd(fd);
 }
 
 static void cgroup_fd_array_put_ptr(void *ptr)
-- 
1.8.3.1

