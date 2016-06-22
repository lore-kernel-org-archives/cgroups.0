From: Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH -next 0/4] cgroup: bpf: cgroup2 membership test on skb
Date: Tue, 21 Jun 2016 17:23:18 -0700
Message-ID: <1466555002-1316296-1-git-send-email-kafai@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : mime-version : content-type; s=facebook;
 bh=EisUnq4pYBG4LnTzyfkSW+TqpOr1sbEvDGkAhmlZ4ck=;
 b=f/Gx5gk/n/cmjXbpc0/PhYDAa8D1WltoZMBZ9LrXFrPli0d9lKgLDtuMM0HQTm3Zl95f
 2DT10JK9fHuzHdzdSdYe6jGfQjdgkVCThpfVZ2/n6vf45rytM+URRW4jhNZRS+Zg6gUp
 ouT4xtbZnffWxeLikClNZmUpRJNxUn7qzmk= 
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alexei Starovoitov <ast-b10kYP2dOMg@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

This series is to implement a bpf-way to
check the cgroup2 membership of a skb (sk_buff).

It is similar to the feature added in netfilter:
c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")

The current target is the tc-like usage.
