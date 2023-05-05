From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Fri, 5 May 2023 06:03:48 -1000
Message-ID: <ZFUo5IYAIwTEKR4_@slm.duckdns.org>
References: <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
 <ZDmFLfII8EUX_ocY@slm.duckdns.org>
 <c61ca9d0-c514-fb07-c2f2-3629e8898984@redhat.com>
 <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
 <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
 <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
 <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
 <ZFGOTHQj3k5rzmyR@blackbook>
 <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683302632; x=1685894632;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zQKJTg5ApR448/3rL3jZGIW7r7Tt+TftEzg/PrUenB8=;
        b=KdeViUdQB/XlTtwKjiqtdqzxGXJNnUwIDquRJ+lSj2VGU9tE1P0MAkcVPmNkcz6vHB
         fDXCRHapjvFVEV3o1VGhvwLDLqnYkDZk590OXp4RU/dg1K9J4irJGis253sNeWuqWAHu
         N/LRTdnrS4B20Cwt15aQB3erb35WH+otXfr8XUrmfXJ5F0YNoIEPGGTqcVdo6AqE2RYy
         J7XuI0QXsJZknjLlLhZHvKE2H0pbe5RlsDzZgofl+XV4kim3baGkMM9j0zEi/klPxtaQ
         onIuV02H251+0B0rKEGb09NzWZixob41Xeurhro2dcypBvg34lEmo7vXh51YUQDZ8RoK
         gZmg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed, May 03, 2023 at 11:01:36PM -0400, Waiman Long wrote:
> 
> On 5/2/23 18:27, Michal Koutný wrote:
> > On Tue, May 02, 2023 at 05:26:17PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > In the new scheme, the available cpus are still directly passed down to a
> > > descendant cgroup. However, isolated CPUs (or more generally CPUs dedicated
> > > to a partition) have to be exclusive. So what the cpuset.cpus.reserve does
> > > is to identify those exclusive CPUs that can be excluded from the
> > > effective_cpus of the parent cgroups before they are claimed by a child
> > > partition. Currently this is done automatically when a child partition is
> > > created off a parent partition root. The new scheme will break it into 2
> > > separate steps without the requirement that the parent of a partition has to
> > > be a partition root itself.
> > new scheme
> >    1st step:
> >    echo C >p/cpuset.cpus.reserve
> >    # p/cpuset.cpus.effective == A-C (1)
> >    2nd step (claim):
> >    echo C' >p/c/cpuset.cpus # C'⊆C
> >    echo root >p/c/cpuset.cpus.partition
> 
> It is something like that. However, the current scheme of automatic
> reservation is also supported, i.e. cpuset.cpus.reserve will be set
> automatically when the child cgroup becomes a valid partition as long as the
> cpuset.cpus.reserve file is not written to. This is for backward
> compatibility.
> 
> Once it is written to, automatic mode will end and users have to manually
> set it afterward.

I really don't like the implicit switching behavior. This is interface
behavior modifying internal state that userspace can't view or control
directly. Regardless of how the rest of the discussion develops, this part
should be improved (e.g. would it work to always try to auto-reserve if the
cpu isn't already reserved?).

Thanks.

-- 
tejun
