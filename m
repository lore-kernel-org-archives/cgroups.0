From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 03/18] memcontrol: present maximum used memory also for
 cgroup-v2
Date: Tue, 14 Jun 2016 17:15:06 +0000
Message-ID: <db6a51eb-d1f7-691b-11a6-ef0b7c1c9462@gmail.com>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-4-git-send-email-toiwoton@gmail.com>
 <20160614070130.GB5681@dhcp22.suse.cz>
 <b9d04ccd-28d2-993a-2a40-bbed7b6289d4@gmail.com>
 <20160614160410.GB14279@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=JkUs1f+nogTVIk+5iURpRnuXlrdqayW2347MT11IzxI=;
        b=oX+TbJVyJdlU76rsUW2ef5DOFnkWlsC0F1OOyhDVppMrmhec48ayZGzcn0BKKSfVMs
         KFlDzIt1qivG89tyN3QTi4GVxhNj/ApCXOVtOAtKuVuDR/I748EyyX+o6IrS3vdfgQok
         A1+ecFKZ3Y4NQdMTc0Em7TjQFWyX1fC6y3DbIo32edmPY0KM6iAi+aVO/Be7WpaaPsIM
         173S/zR5dudyS+cyTczMf+dREjqefQlEFUDlfYFsnjfNtlpg6vwqTvbzHfBL0vpL13pk
         cBHuPED496J46DZDL4QTMFkTHcsqdxmtsKFctwhicyk+iA7hA7LoN8/YU2fMO2vDcTFd
         DRZw==
In-Reply-To: <20160614160410.GB14279-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On 06/14/16 16:04, Johannes Weiner wrote:
> On Tue, Jun 14, 2016 at 03:47:20PM +0000, Topi Miettinen wrote:
>> On 06/14/16 07:01, Michal Hocko wrote:
>>> On Mon 13-06-16 22:44:10, Topi Miettinen wrote:
>>>> Present maximum used memory in cgroup memory.current_max.
>>>
>>> It would be really much more preferable to present the usecase in the
>>> patch description. It is true that this information is presented in the
>>> v1 API but the current policy is to export new knobs only when there is
>>> a reasonable usecase for it.
>>>
>>
>> This was stated in the cover letter:
>> https://lkml.org/lkml/2016/6/13/857
>>
>> "There are many basic ways to control processes, including capabilities,
>> cgroups and resource limits. However, there are far fewer ways to find out
>> useful values for the limits, except blind trial and error.
>>
>> This patch series attempts to fix that by giving at least a nice starting
>> point from the actual maximum values. I looked where each limit is checked
>> and added a call to limit bump nearby."
>>
>> "Cgroups
>> [RFC 02/18] cgroup_pids: track maximum pids
>> [RFC 03/18] memcontrol: present maximum used memory also for
>> [RFC 04/18] device_cgroup: track and present accessed devices
>>
>> For tasks and memory cgroup limits the situation is somewhat better as the
>> current tasks and memory status can be easily seen with ps(1). However, any
>> transient tasks or temporary higher memory use might slip from the view.
>> Device use may be seen with advanced MAC tools, like TOMOYO, but there is no
>> universal method. Program sources typically give no useful indication about
>> memory use or how many tasks there could be."
>>
>> I can add some of this to the commit message, is that sufficient for you?
> 
> It's useful to have a short summary of the justification in each patch
> as well. Other than that it's fine to be broader and more detailed
> about your motivation in the coverletter.
> 
> I didn't catch the coverletter, though. It makes sense to CC
> recipients of any of those patches on the full series, including the
> cover, since even though we are specialized in certain areas of the
> code, many of us are interested in the whole picture of addressing a
> problem, and not just the few bits in our area without more context.
> 

Thank you for this nice explanation. I suppose "git send-email
--cc-cmd=scripts/get_maintainer.pl" doesn't do this.

> As far as the memcg part of this series goes, one concern is that page
> cache is trimmed back only when there is pressure, so in all but very
> few cases the high watermark you are introducing will be pegged to the
> configured limit. It doesn't give a whole lot of insight.
> 

So using the high watermark would not give a very useful starting point
for the user who wished to configure the memory limit? What else could
be used instead?

> But there are consumers that are less/not compressible than cache,
> such as anonymous memory, unreclaimable slab, maybe socket buffers
> etc. Having spikes in those slip through two sampling points is an
> issue, indeed. Adding consumer-specific watermarks might be useful.
> 
> Thanks
> 

OK, but there's no limiting or tuning mechanism in place for now for
those, or is there? How could the results be used?

-Topi
