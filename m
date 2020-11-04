From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: replace '== root_mem_cgroup' with
 mem_cgroup_is_root
Date: Wed, 4 Nov 2020 14:46:22 -0800
Message-ID: <20201104224622.GE1938922@carbon.dhcp.thefacebook.com>
References: <20201104151457.GA108301@rlk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=i6hIhBbaplErdssUdp2AQT9+surBNka9EcYDoCuFP4M=;
 b=NgH/bpVxgY9Twb6BSxSYi4JIJUuXO2QKcFMhKuHVMtqkl/EZ1tVde1aD7aNO4/EfsScm
 hb+hz5NTt0e8d/2nB1KsoePOlfRu94r7Yr5VPV9PiEN8bAvIKs8E/V4cuxR4e9zED64E
 wxiGmrG3TGda31g+3rvUXJ1bEflK0ze/FB8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6hIhBbaplErdssUdp2AQT9+surBNka9EcYDoCuFP4M=;
 b=Dt4vTToEgdwxYUPsaA4N67Le5i+Yf9/SZIPgDH3Wbz50cAIEzIwq/nS3np/YSSIdoKhDhCf38ovuKHDR3fpzB+ZQXhSuvAp/fZq85zF0i9Vdhh+bNZ+JuMuY6yJUsFOd9uMC6Bf7qUdc548yHABzA3ZBXZBM+Uo4FucCvsOr/6Y=
Content-Disposition: inline
In-Reply-To: <20201104151457.GA108301@rlk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 04, 2020 at 11:14:57PM +0800, Hui Su wrote:
> We have supplied the inline func: mem_cgroup_is_root().
> So we may use mem_cgroup_is_root() instead of using
> 'memcg == root_mem_cgroup' or 'memcg != root_mem_cgroup'
> directly, which is more readable.

Most of these comparisons will go away soon:
https://lkml.org/lkml/2020/10/21/612 (this is
an rfc version, I'll send an updated version soon).

Thanks!
