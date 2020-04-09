From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 18:50:44 +0100
Message-ID: <20200409175044.GC1040020@chrisdown.name>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
 <20200409094615.GE18386@dhcp22.suse.cz>
 <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
 <20200409103400.GF18386@dhcp22.suse.cz>
 <20200409170926.182354c3@hemera.lan.sysophe.eu>
 <20200409152417.GB1040020@chrisdown.name>
 <20200409174042.2a3389ba@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=217s5pRKcKbRlTJmbY5WRFxIFluRiLBTdWkIUP+x/Lw=;
        b=N6TkqbaMwLt4RT+I4MLjB4FBpaniFECZkDEfAw7OFhqvHoFsJ9Jo+6X1G4Mx2MQCMP
         4TuH+6KoU8y9WlMlBYZtZ8dQH93WdRjq5HaNl+qH6re/8jvcO9p8/wUEZmBEWB4ZCrhJ
         GxeMNDN1dH84JCPlhcPdBZCArChJeA2J8Yl7w=
Content-Disposition: inline
In-Reply-To: <20200409174042.2a3389ba-pDZhbqX7CfkoGc32E1+a2S4z1YicLaQ4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Bruno Pr=E9mont writes:
>On Thu, 9 Apr 2020 16:24:17 +0100 wrote:
>
>> Bruno Pr=E9mont writes:
>> >Could it be that cache is being prevented from being reclaimed by a task
>> >in another cgroup?
>> >
>> >e.g.
>> >  cgroup/system/backup
>> >    first reads $files (reads each once)
>> >  cgroup/workload/bla
>> >    second&more reads $files
>> >
>> >Would $files remain associated to cgroup/system/backup and not
>> >reclaimed there instead of being reassigned to cgroup/workload/bla?
>>
>> Yes, that's entirely possible. The first cgroup to fault in the pages is
>> charged for the memory. Other cgroups may use them, but they are not acc=
ounted
>> for as part of that other cgroup. They may also still be "active" as a r=
esult
>> of use by another cgroup.
>
>But the memory would then be 'active' in the original cgroup? which is
>not the case here I feel.

Yes, that's correct. I don't think it's the case here (since active_file is=
 not=20
that large in the affected cgroup), but it's certainly generally a possibil=
ity.
