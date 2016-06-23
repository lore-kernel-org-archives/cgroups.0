From: Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH net-next v2 3/4] cgroup: bpf: Add bpf_skb_in_cgroup_proto
Date: Thu, 23 Jun 2016 14:41:40 -0700
Message-ID: <20160623214140.GB90834@kafai-mba.DHCP.thefacebook.com>
References: <1466630252-3822277-1-git-send-email-kafai@fb.com>
 <1466630252-3822277-4-git-send-email-kafai@fb.com>
 <576BB1AE.5080605@iogearbox.net>
 <20160623165449.GC82305@kafai-mba.local>
 <576C417F.6000301@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=BWuxOK4yjProJ1oGh7W6EqZiPzvFEWSJ884HEVHQhXs=;
 b=HpeGkceW5CxMTVR+oFeVNedPtJdw+3NRYQsnYuugGC7IvyRfDCFtmWvbMZyPdbqyhU2l
 3/aAU1aDbAWwjswpjVMkeYg7Q/cI2zDrH9pqbA/CHdmoBTjXLLGy379BxKvoquVv9nIx
 gtso6EFO2S7CBGuv6Ty/Z9inpoZfc4YnIaM= 
Content-Disposition: inline
In-Reply-To: <576C417F.6000301@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Thu, Jun 23, 2016 at 10:07:27PM +0200, Daniel Borkmann wrote:
> On 06/23/2016 06:54 PM, Martin KaFai Lau wrote:
> >On Thu, Jun 23, 2016 at 11:53:50AM +0200, Daniel Borkmann wrote:
> >>>diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>>index 668e079..68753e0 100644
> >>>--- a/kernel/bpf/verifier.c
> >>>+++ b/kernel/bpf/verifier.c
> >>>@@ -1062,6 +1062,10 @@ static int check_map_func_compatibility(struct bpf_map *map, int func_id)
> >>>  		if (func_id != BPF_FUNC_get_stackid)
> >>>  			goto error;
> >>>  		break;
> >>>+	case BPF_MAP_TYPE_CGROUP_ARRAY:
> >>>+		if (func_id != BPF_FUNC_skb_in_cgroup)
> >>>+			goto error;
> >>>+		break;
> >>
> >>I think the BPF_MAP_TYPE_CGROUP_ARRAY case should have been fist here in
> >>patch 2/4, but with unconditional goto error. And this one only adds the
> >>'func_id != BPF_FUNC_skb_in_cgroup' test.
> >I am not sure I understand.  Can you elaborate? I am probably missing
> >something here.
>
> If someone backports patch 2/4 as-is, but for some reason not 3/4, then you
> could craft a program that calls f.e. bpf_map_update_elem() on a cgroup array
> and would thus cause a NULL pointer deref, since verifier doesn't prevent it.
> I'm just trying to say that it would probably make sense to add the above 'case
> BPF_MAP_TYPE_CGROUP_ARRAY:' with an unconditional 'goto error' in patch 2/4
> and extend upon it in patch 3/4 so result looks like here, so that the patches
> are fine/complete each as stand-alone.
I failed to connect some points in your last comment.  Thanks for explaining.

Make sense. I will spin v3.
