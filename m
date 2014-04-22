From: Tim Hockin <thockin@google.com>
Subject: Re: Protection against container fork bombs [WAS: Re: memcg with kmem
 limit doesn't recover after disk i/o causes limit to be hit]
Date: Tue, 22 Apr 2014 13:13:00 -0700
Message-ID: <CAO_RewZki4qihUTab+g-N_dpGnmH2kJ3nYhV2pjR2QfWNW6CnQ@mail.gmail.com>
References: <20140416154650.GA3034@alpha.arachsys.com> <20140418155939.GE4523@dhcp22.suse.cz>
 <5351679F.5040908@parallels.com> <20140420142830.GC22077@alpha.arachsys.com>
 <20140422143943.20609800@oracle.com> <20140422200531.GA19334@alpha.arachsys.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=j0DWp6ZKTkPkLPI5sV9Kigma1fMyp4pOshFSuzzZmw4=;
        b=jEp0lXKh7u3NDurqiSV2MN2z80u4kQGXiI0e5gWpYUaWTBREpSzMeQJ2OFAwR6xdqq
         g/IdP23xtE5DfkMCegA+hIAUHFMhJgYMlRgPWdXjG/b9ytkbXL1dyywRZ1/II3WCetNS
         PZ/x3ZKJajfwOgqBg/gOcuzTJe7OlbNME/oGrfBodBl6HvlXtkimpJN/Ga6nwvoQYXGw
         M5kB5fRWaG4qaAxCUw4MnEOWvUlt4DXMqOu8NswNSBM6Oaxhr+heN052McNUEYj6zmT8
         M96UQUbL94o3MKb8Ab+Z/I41s30XM1fmylnIS0O5sDUIe1fyKczx2MF0NpyKOnM1USjM
         +Y/w==
In-Reply-To: <20140422200531.GA19334@alpha.arachsys.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Davies <richard@arachsys.com>
Cc: Dwight Engen <dwight.engen@oracle.com>, Vladimir Davydov <vdavydov@parallels.com>, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>, Max Kellermann <mk@cm4all.com>, Johannes Weiner <hannes@cmpxchg.org>, William Dauchy <wdauchy@gmail.com>, Tim Hockin <thockin@hockin.org>, Michal Hocko <mhocko@suse.cz>, Daniel Walsh <dwalsh@redhat.com>, Daniel Berrange <berrange@redhat.com>, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>

Who in kernel-land still needs to be convinced of the utility of this idea?

On Tue, Apr 22, 2014 at 1:05 PM, Richard Davies <richard@arachsys.com> wrote:
> Dwight Engen wrote:
>> Richard Davies wrote:
>> > Vladimir Davydov wrote:
>> > > In short, kmem limiting for memory cgroups is currently broken. Do
>> > > not use it. We are working on making it usable though.
> ...
>> > What is the best mechanism available today, until kmem limits mature?
>> >
>> > RLIMIT_NPROC exists but is per-user, not per-container.
>> >
>> > Perhaps there is an up-to-date task counter patchset or similar?
>>
>> I updated Frederic's task counter patches and included Max Kellermann's
>> fork limiter here:
>>
>> http://thread.gmane.org/gmane.linux.kernel.containers/27212
>>
>> I can send you a more recent patchset (against 3.13.10) if you would
>> find it useful.
>
> Yes please, I would be interested in that. Ideally even against 3.14.1 if
> you have that too.
>
> Thanks,
>
> Richard.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
