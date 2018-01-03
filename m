From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroup.stat
Date: Wed, 3 Jan 2018 01:38:18 +0100
Message-ID: <7cfbf94e-71c8-b49e-7483-79c3fa363191@gmail.com>
References: <196c0cca-b573-8c65-2b5f-66376f79a836@gmail.com>
 <20180102215726.GA2606@castle>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mNgAwjfwBgxCpFast1Z5R+PSlRw4J7MbSrVvqirmDCY=;
        b=c+tPBNTkkx43aftcxqk8936MnVDLeKcqO+X67bpLberZlHTFEuhBa6VRFi6piqcXcS
         eUowIFHTD9DDbH34fJwrpMDV+43MMow80NDo52d9yJ3JoNhfJdrUPew+n9eanFtL4UUq
         28O2bqSGnFiwuuLQ7xNg6KrRqeCxbQAfp0dRh6iHv0B3JpM02PZY4BbJjz1ktM22LCEI
         huWHjEPvWmETiGUfP+slpsbm/eVf3ACcJlnS1T3REGumWMzuueZyzt8oB8RyPostPot9
         3Jmnr0QddynDrIfF7QomYbHV3j9ZghQq6ggI0XaAyxYvSy6iIlTiIdw0g9p8fiyuMeTC
         aQWw==
In-Reply-To: <20180102215726.GA2606@castle>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Roman,

On 01/02/2018 10:57 PM, Roman Gushchin wrote:
> Hello, Michael!
> 
> Thank you for working on this!

You're welcome. Thanks for reviewing the text!

> Please, find my comments below.
> 
> On Tue, Jan 02, 2018 at 07:22:33PM +0100, Michael Kerrisk (man-pages) wrote:
>> Hello Roman,
>>
>> I wish to add documentation to cgroups(7) for the cgroup.stat file
>> that you added in Linux 4.14. I wrote some text based on your text
>> added to the cgroup-v2.txt file, but added some pieces, and also have
>> a question (see below). The plain-text version for (easy review)
>> is shown below. Could you please review this text? (Please note 
>> the FIXME!)
>>
>> The branch containing the pending cgroups(7) changes can be found at :
>> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates
>>
>> [[
>>    Cgroups v2 cgroup.stat file
>>        Each   cgroup   in   the  v2  hierarchy  contains  a  read-only
>>        cgroup.stat file (first introduced in Linux 4.14) that consists
>>        of  lines  containing key-value pairs.  The following keys cur‐
>>        rently appear in this file:
>>
>>        nr_descendants
>>               This is the  total  number  of  visible  (i.e.,  living)
>>               descendant cgroups underneath this cgroup.
>>
>>               ┌─────────────────────────────────────────────────────┐
>>               │FIXME                                                │
>>               ├─────────────────────────────────────────────────────┤
>>               │For  the  following text on nr_dying_descendants, it │
>>               │would I think be  helpful  to  describe  a  condrete │
>>               │example of when one might see nr_dying_descendants a │
>>               │nonzero value for this  key.  Ideally,  the  example │
>>               │would be one that the reader could easily reproduce. │
>>               │Is there such an example?                            │
>>               └─────────────────────────────────────────────────────┘
> 
> Hm, basically any cgroup which had some pagecache, associated during the
> lifetime, will spend some time in the dying state. This means that for
> most cgroups this number will be non-zero for some amount of time,
> which depends on global memory pressure.
> It's also very implementation-defined, and will be likely changed
> in the following kernel versions.
> 
> So, I'm not sure, that such an example will be useful for a user.
> Until this number is huge and constantly growing, it shouldn't be
> interesting for an user at all.

Fair enough. I added some vague text about resources needing to be freed
before the cgroup is destroyed. See below.


>>        nr_dying_descendants
>>               This is the total number  of  dying  descendant  cgroups
>>               underneath this cgroup.  A cgroup enters the dying state
>>               after being deleted.  It remains in that  state  for  an
>>               undefined  period  (which  will  depend  on system load)
>>               before being destroyed.
>>
>>               A process can't be made a member of a dying cgroup,  and
>>               a dying cgroup can't be brought back to life.
> 
> So, maybe it worth it to add a statement, that some amount of dying cgroups
> is normal and it's not a signal of any problem?

Okay, I added some text along those lines. The first paragraph now reads:

       nr_dying_descendants
              This is the total number  of  dying  descendant  cgroups
              underneath this cgroup.  A cgroup enters the dying state
              after being deleted.  It remains in that  state  for  an
              undefined  period  (which  will  depend  on system load)
              while  resources  are  freed  before   the   cgroup   is
              destroyed.   Note  that  the presence of some cgroups in
              the dying state is normal, and is not indicative of  any
              problem.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
