From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for
 bpf map
Date: Thu, 18 Aug 2022 12:20:33 -1000
Message-ID: <Yv67MRQLPreR9GU5@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=tr2YfKFFpUU37xf4ManQv+y3/4pV4AbAVOF71yP0UDM=;
        b=KY80Ec2EYHn5WFnbgKROZvwVrPBKR9TCPDJ4Bw/+YH1nWvZ8zBC4HiM3kL62FVSIHI
         V0sdJqE1+X9/hYSAmkHX0ttVunBfUUbxdDrijYE1S/aTAyrKetMJtSJdoIjYHfPOQ3gD
         BQwpS4K/1PXEiiH3xvM+lKbDEHg7ytztTUVJXVqOAJI9gHejz/CO3QZAQx8IfbGXsn4J
         5bGMKpnl8EWu/l4SxhTYFUOiXMIhjxYbCo3JCHVlgJw0rKdbSnaJKuxVV3Hg2XNzKGy/
         ykd1zcDd2xq+d6sycmuHscFeHGXchvlK3L+cVKS4i45SaDcrLIhwWniy+rYMw7SUKrM1
         BomA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220818143118.17733-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello,

On Thu, Aug 18, 2022 at 02:31:06PM +0000, Yafang Shao wrote:
> After switching to memcg-based bpf memory accounting to limit the bpf
> memory, some unexpected issues jumped out at us.
> 1. The memory usage is not consistent between the first generation and
> new generations.
> 2. After the first generation is destroyed, the bpf memory can't be
> limited if the bpf maps are not preallocated, because they will be
> reparented.
> 
> This patchset tries to resolve these issues by introducing an
> independent memcg to limit the bpf memory.

memcg folks would have better informed opinions but from generic cgroup pov
I don't think this is a good direction to take. This isn't a problem limited
to bpf progs and it doesn't make whole lot of sense to solve this for bpf.

We have the exact same problem for any resources which span multiple
instances of a service including page cache, tmpfs instances and any other
thing which can persist longer than procss life time. My current opinion is
that this is best solved by introducing an extra cgroup layer to represent
the persistent entity and put the per-instance cgroup under it.

It does require reorganizing how things are organized from userspace POV but
the end result is really desirable. We get entities accurately representing
what needs to be tracked and control over the granularity of accounting and
control (e.g. folks who don't care about telling apart the current
instance's usage can simply not enable controllers at the persistent entity
level).

We surely can discuss other approaches but my current intuition is that it'd
be really difficult to come up with a better solution than layering to
introduce persistent service entities.

So, please consider the approach nacked for the time being.

Thanks.

-- 
tejun
