From: Yonghong Song <yhs@fb.com>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Tue, 22 Mar 2022 11:09:41 -0700
Message-ID: <f049c2f6-499b-ff7a-3910-38487878606a@fb.com>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
 <Yi7ULpR70HatVP/8@slm.duckdns.org>
 <CAJD7tkYGUaeeFMJSWNbdgaoEq=kFTkZzx8Jy1fwWBvt2WEfqAA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0R6AdsNxQYKtlx7c+ZJCr8SBiOh+ERMXe+tI/ibvU3U=;
 b=GQ/WaR9OUbPS7ycajmt3WsfD633j0J+jJdANZ5ANXOOY6+e/YkR2dzq4iyMMWOBQ6IFV
 MKiyZFlS2A1OF9KDEFwkmm1/4lG0arcapo4qQoKxsXYNnKvE3rfL47WqruoThvoezcBi
 ZYaxh13DHA8iYyUOlmyh06E93QdErsA4Ba0= 
Content-Language: en-US
In-Reply-To: <CAJD7tkYGUaeeFMJSWNbdgaoEq=kFTkZzx8Jy1fwWBvt2WEfqAA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Shakeel Butt <shakeelb@google.com>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, bpf <bpf@vger.kernel.org>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>



On 3/16/22 9:35 AM, Yosry Ahmed wrote:
> Hi Tejun,
> 
> Thanks for taking the time to read my proposal! Sorry for the late
> reply. This email skipped my inbox for some reason.
> 
> On Sun, Mar 13, 2022 at 10:35 PM Tejun Heo <tj@kernel.org> wrote:
>>
>> Hello,
>>
>> On Wed, Mar 09, 2022 at 12:27:15PM -0800, Yosry Ahmed wrote:
>> ...
>>> These problems are already addressed by the rstat aggregation
>>> mechanism in the kernel, which is primarily used for memcg stats. We
>>
>> Not that it matters all that much but I don't think the above statement is
>> true given that sched stats are an integrated part of the rstat
>> implementation and io was converted before memcg.
>>
> 
> Excuse my ignorance, I am new to kernel development. I only saw calls
> to cgroup_rstat_updated() in memcg and io and assumed they were the
> only users. Now I found cpu_account_cputime() :)
> 
>>> - For every cgroup, we will either use flags to distinguish BPF stats
>>> updates from normal stats updates, or flush both anyway (memcg stats
>>> are periodically flushed anyway).
>>
>> I'd just keep them together. Usually most activities tend to happen
>> together, so it's cheaper to aggregate all of them in one go in most cases.
> 
> This makes sense to me, thanks.
> 
>>
>>> - Provide flags to enable/disable using per-cpu arrays (for stats that
>>> are not updated frequently), and enable/disable hierarchical
>>> aggregation (for non-hierarchical stats, they can still make benefit
>>> of the automatic entries creation & deletion).
>>> - Provide different hierarchical aggregation operations : SUM, MAX, MIN, etc.
>>> - Instead of an array as the map value, use a struct, and let the user
>>> provide an aggregator function in the form of a BPF program.
>>
>> I'm more partial to the last option. It does make the usage a bit more
>> compilcated but hopefully it shouldn't be too bad with good examples.
>>
>> I don't have strong opinions on the bpf side of things but it'd be great to
>> be able to use rstat from bpf.
> 
> It indeed gives more flexibility but is more complicated. Also, I am
> not sure about the overhead to make calls to BPF programs in every
> aggregation step. Looking forward to get feedback on the bpf side of
> things.

Hi, Yosry, I heard this was discussed in bpf office hour which I
didn't attend. Could you summarize the conclusion and what is the
step forward? We also have an internal tool which collects cgroup
stats and this might help us as well. Thanks!

> 
>>
>> Thanks.
>>
>> --
>> tejun
