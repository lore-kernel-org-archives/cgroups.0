From: Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [sparc64] fails to boot, (was: Re: [PATCH memcg v6] net: set
 proper memcg for net_init hooks allocations)
Date: Wed, 28 Sep 2022 09:54:35 +0200
Message-ID: <a66880d7-fc2e-4fa7-0711-5d93b4304607@leemhuis.info>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org>
 <20220918092849.GA10314@u164.east.ru>
 <eca7d9b3-9831-5d04-1f39-8976765df87a@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Language: en-US, de-DE
In-Reply-To: <eca7d9b3-9831-5d04-1f39-8976765df87a@suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vlastimil Babka <vbabka@suse.cz>, Anatoly Pugachev <matorola@gmail.com>, Vasily Averin <vvs@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, cgroups@vger.kernel.org, sparclinux@vger.kernel.org, regressions@lists.linux.dev

On 27.09.22 11:54, Vlastimil Babka wrote:
> On 9/18/22 11:28, Anatoly Pugachev wrote:
>> On Fri, Jun 03, 2022 at 07:19:43AM +0300, Vasily Averin wrote:
>>> __register_pernet_operations() executes init hook of registered
>>> pernet_operation structure in all existing net namespaces.
>> [...]
>> I'm unable to boot my sparc64 VM anymore (5.19 still boots, 6.0-rc1 does not),
>> bisected up to this patch,
>>
>> mator@ttip:~/linux-2.6$ git bisect bad
>> 1d0403d20f6c281cb3d14c5f1db5317caeec48e9 is the first bad commit
>> commit 1d0403d20f6c281cb3d14c5f1db5317caeec48e9
>> [...]
> 
> #regzbot introduced: 1d0403d20f6c

Thx for getting this regression tracked using regzbot. FWIW, that went
sideways (as your already noticed and mentioned on IRC), as that made
regzbot treat *your* mail as the report of the regressions. In cases
like this you need "#regzbot ^introduced 1d0403d20f6c" (since recently
"#regzbot introduced 1d0403d20f6c ^" works, too), as then regzbot will
consider the *parent* mail the report (and then regzbot will look out
for patches that link to them using a Link: tag).

No worries, I did the same mistake a few time already :-D I send a mail
with that command now, so let's resolve this subthread by marking it invalid

#regzbot invalid: mis-used regzbot command, now properly tracked

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

