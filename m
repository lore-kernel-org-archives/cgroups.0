From: Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH net-next v2 2/4] cgroup: bpf: Add
 BPF_MAP_TYPE_CGROUP_ARRAY
Date: Thu, 23 Jun 2016 15:10:15 -0700
Message-ID: <20160623221015.GA93293@kafai-mba.DHCP.thefacebook.com>
References: <1466630252-3822277-1-git-send-email-kafai@fb.com>
 <1466630252-3822277-3-git-send-email-kafai@fb.com>
 <576BAF07.4020302@iogearbox.net>
 <20160623212616.GA90834@kafai-mba.DHCP.thefacebook.com>
 <576C5990.9000300@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=tOGdCkeRAwMAvhgd6GlfCKKcBC8P47+Ecm/8JUgqots=;
 b=RVItYYeZbDRm+povtvC7v2GZCdU0lwjac+q92lVQ+w368qHRUmsSiHNFpIS7cJDu3+xJ
 L3NSYkT1xx2BW2gtAszxHnH0SU7Rw0wfWgfKkqiZ362Kp+ZFsimmClRSrgt0vN/h8enh
 rPODDkpv6sEkm8D6JKpMWoOVUxb865QrkRI= 
Content-Disposition: inline
In-Reply-To: <576C5990.9000300@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Thu, Jun 23, 2016 at 11:50:08PM +0200, Daniel Borkmann wrote:
> On 06/23/2016 11:26 PM, Martin KaFai Lau wrote:
> >We are still hatching out how to set this up in production. However, the
> >situation is similar to removing the pinned file.
s/pinned file/pinned cgroup-array/

> I presume you mean removing the last BPF program holding a reference on
> the cgroup array map.
Yes

> (Any user space visibility like struct files given
> from the anon inode and pinnings are tracked via uref, btw, which is
> needed to break possible complex dependencies among tail called programs.)
Yep. Understood on prog_array use case.

Thanks,
-- Martin
