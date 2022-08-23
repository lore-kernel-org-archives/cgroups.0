From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Tue, 23 Aug 2022 23:43:51 +0800
Message-ID: <a562ede6-262c-b31b-4c96-75a69c265c41@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvKd6dezPM6UxfD/@slm.duckdns.org>
 <fcd0bd39-3049-a279-23e6-a6c02b4680a7@bytedance.com>
 <b89155d3-9315-fefc-408b-4cf538360a1c@bytedance.com>
 <YvPN07UlaPFAdlet@cmpxchg.org> <20220815132343.GA22640@blackbody.suse.cz>
 <9d1997a4-9278-07bd-7f57-952306b28b14@bytedance.com>
 <YwTz32VWuZeLHOHe@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=WdZUWMe+w6NdkvEjJaHucwMuy21ym8cPJg6eP925ZQ0=;
        b=UhhdlLKQ2gDM2vQTqxNR3H3P54QELCmTYoRtFWOv3E2w4om1CvRbYVwedRQTd+Afao
         0qpcZIs3VEdxcpn3t4fBlWL3FsZsdeDru+azac3lUBr84uuKZTZ3mlZIQxwNYTEZ0+C3
         8myH9iaSwznHp48212VmuEt2w9h9vxetHBO1SHhA4XfmymVTL5vD34Si4OZGaZxmyCXq
         JZG25rmhvCeKVbiXdYQMg17r6Lw9PzEXpisKPi4dfNc9NyP3gXR5ayybTb+TbfD2MB3B
         gYFlnt6Ovve7/HS9Ci6ZQe4S/dcIGq/iyuwy9Rlll8tcHQ8vwDqGYJC8Fdolad+HrDWr
         CHFw==
Content-Language: en-US
In-Reply-To: <YwTz32VWuZeLHOHe@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On 2022/8/23 23:35, Johannes Weiner wrote:
> On Tue, Aug 23, 2022 at 02:18:21PM +0800, Chengming Zhou wrote:
>> On 2022/8/15 21:23, Michal Koutn=C3=BD wrote:
>>> On Wed, Aug 10, 2022 at 11:25:07AM -0400, Johannes Weiner <hannes@cmpxc=
hg.org> wrote:
>>>> cgroup.pressure.enable sounds good to me too. Or, because it's
>>>> default-enabled and that likely won't change, cgroup.pressure.disable.
>>>
>>> Will it not change?
>>>
>>> I'd say that user would be interested in particular level or even just
>>> level in subtree for PSI, so the opt-out may result in lots of explicit
>>> disablements (or even watch for cgroups created and disable PSI there)
>>> to get some performance back.
>>>
>>> I have two suggestions based on the above:
>>> 1) Make the default globally configurable (mount option?)
>>> 2) Allow implicit enablement upon trigger creation
>>>
>>
>> I think suggestion 1) make sense in some use case, like make per-cgroup
>> PSI disabled by default using a mount option, then enable using the
>> "cgroup.pressure" interface.
>>
>> But suggestion 2) auto enable upon trigger creation, if we hide the
>> {cpu,memory,io}.pressure files when disabled, how can we create trigger?
>>
>> Want to see what do Johannes and Tejun think about these suggestions?
>=20
> Re 1: I agree. If desired in the future we can make the default
> configurable. Kconfig, mount option, what have you. cgroup.pressure
> will work fine as a name regardless of what the default is.
>=20
> Re 2: Not all consumers of the pressure metrics create trigger. I
> would argue that few do. So it isn't the best signal to decide on
> whether aggregation should occur. And yes, it's further complicated by
> the triggers being written to the very pressure files. If we don't
> hide them, we have to come up with another way to mark them as stale,
> lest they confuse the heck out of users. Without breaking format...
>=20
> So IMO, default-enable, "cgroup.pressure" as a name, and hiding the
> pressure files should be good for now while allowing to make the
> default configurable down the line.

Agree, it's what we want for now. Thanks for your reply!


