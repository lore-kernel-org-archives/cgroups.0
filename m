From: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 5/5] mm/memcg: Optimize user context object stock
 access
Date: Thu, 15 Apr 2021 08:16:53 -0400
Message-ID: <20210415121653.dotuf6253s5yuhae@gabell>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-6-longman@redhat.com>
 <20210415032836.lohexqge3cvpsqoa@gabell>
 <alpine.DEB.2.22.394.2104151143080.632904@gentwo.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vWuMPoAE8UBxHeNo7QhXBPsmih0P+8U7Q8QiWirp95g=;
        b=QEPR7zW4F2buJfe2/0q/Do+HgnihvLvH75yFZXYoSIEAsd5pvO2VZsskORw9FaK3qT
         bcZn9AeJubvP+XKoDHKYPm17f5EnqO6SnyFbevyQpdLFd/dgjC8NtoAynIjQtSipvppY
         IKclDl5Wb55AG6gDcd55/LzTdzszDj/5h/oXHSpOMWj0JcWG67nS8W3Mi7BRYfpuNjAV
         98bZ0lymWQAsgfYv6Dq5dXZAOz/V/hYV67v6JD2mIh7ICfEbFoBpDUtTVM4s2Wr0wkQj
         yMRK89IE2tJKHj23aKC9y3TPmgaBFzMRLuEr+qKRaih2eEA02VSSOLndN4pCayGugPc6
         HyYQ==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2104151143080.632904-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Thu, Apr 15, 2021 at 11:44:55AM +0200, Christoph Lameter wrote:
> Would you please stop quoting the whole patch when you have nothing to say
> about the details? It is enough to just respond without quoting. I was
> looking through this trying to find something you said about individual
> sections of code but there was nothing.

Thank you for pointing it out and sorry about that.
I'll do that next time.

- Masa
