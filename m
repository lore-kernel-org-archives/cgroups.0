From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Fri, 12 Aug 2022 20:36:17 +0800
Message-ID: <5ce118b3-bf3b-d9a4-004c-a5a355984b0f@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvYoFNDMdg6mdFbU@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=O6llZjz916kr3/4GBc6iVNzZiFC/Zr060/Yj38d12js=;
        b=YGjUxVC/qz3HPVaxeDzBzYHlVqNLt6RJ5F9ItloKWXzWnnI9/MmOEAmhzytYYUehWb
         h7EpbFp8PpGO37viHcMFJCWEe0/kEcA35jUP92VQwxw2mcovAC1Y46LAKi2zQj1mHA1I
         IvSaDmF6rimwod4kWDowrskOK8Tr4pFsc/7ZRNhHs2SZskf15TaNEI+S0GBTmPRjdCPy
         8Vw8vrI/tJ2QSCzyjLl00Om78JuIB1piwLplcb95f5WAnMjDA9HJc0G1emJ1mQwdUgcC
         tot3J+MTymr9NutitLYM3WhGJgQqWoKVZSErRKMOa2KIQlNpChqxExgN4dmJcmknkAjA
         T4Zw==
Content-Language: en-US
In-Reply-To: <YvYoFNDMdg6mdFbU@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, tj@kernel.org, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On 2022/8/12 18:14, Michal Koutn=C3=BD wrote:
> Hello Chengming.
>=20
> On Mon, Aug 08, 2022 at 07:03:40PM +0800, Chengming Zhou <zhouchengming@b=
ytedance.com> wrote:
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/adm=
in-guide/cgroup-v2.rst
>> index dd84e34bc051..ade40506ab80 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -968,6 +968,13 @@ All cgroup core files are prefixed with "cgroup."
>>  	killing cgroups is a process directed operation, i.e. it affects
>>  	the whole thread-group.
>> =20
>> +  cgroup.psi
>> +	A read-write single value file that allowed values are "0" and "1".
>> +	The default is "1".
>> +
>> +	Writing "0" to the file will disable the cgroup PSI stats accounting.
>> +	Writing "1" to the file will re-enable the cgroup PSI stats accounting.
>> +
>=20
> I'd suggest explaining here explicitely, this control attribute is not
> hierarchical (i.e. PSI accounting in a cgroup does not affect accounting
> in descendants and doesn't need pass enablement via ancestors from
> root). And the purpose that it "saves" cycles (where).

Thanks for the suggestion and explanation!

Could you help take a look if there is anything to improve?


--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -968,6 +968,23 @@ All cgroup core files are prefixed with "cgroup."
        killing cgroups is a process directed operation, i.e. it affects
        the whole thread-group.

+  cgroup.pressure
+       A read-write single value file that allowed values are "0" and "1".
+       The default is "1".
+
+       Writing "0" to the file will disable the cgroup PSI accounting.
+       Writing "1" to the file will re-enable the cgroup PSI accounting.
+
+       This control attribute is not hierarchical, so disable or enable PSI
+       accounting in a cgroup does not affect PSI accounting in descendants
+       and doesn't need pass enablement via ancestors from root.
+
+       The reason this control attribute exists is that PSI accounts stall=
s for
+       each cgroup separately and aggregates it at each level of the hiera=
rchy.
+       This may cause non-negligible overhead for some workloads when under
+       deep level of the hierarchy, in which case this control attribute c=
an
+       be used to disable PSI accounting in the cgroups.
+
