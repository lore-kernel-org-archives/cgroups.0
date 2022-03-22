From: Yonghong Song <yhs@fb.com>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Tue, 22 Mar 2022 15:06:41 -0700
Message-ID: <2453e8f6-29fe-c11a-75a4-18644a68d525@fb.com>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
 <Yi7ULpR70HatVP/8@slm.duckdns.org>
 <CAJD7tkYGUaeeFMJSWNbdgaoEq=kFTkZzx8Jy1fwWBvt2WEfqAA@mail.gmail.com>
 <f049c2f6-499b-ff7a-3910-38487878606a@fb.com>
 <CA+khW7jFSmm5sTyAVfEZhYnKDhVZKRRGLgAmCqgZzgON8NJOGg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wllJnS0XqXipMf6tAFjOz4iAppyqxI4/ObmWs7r6k40=;
 b=QzJ/X+N9DsgP11dUOewwzvwIclky3bIi0rKZruL3wu3c6fuxtjGyvfQQEivvmf/u/UGY
 u7J4IfSFKH6qUNYJJfo+mTUpDdPtVuhpAtRNtkE3iUbhSlO08ZPirfwOCZ9ZlLv6E4yy
 +USmXRlT5yFtKbnvwzEV6b3/vWtbOYUbvIs= 
Content-Language: en-US
In-Reply-To: <CA+khW7jFSmm5sTyAVfEZhYnKDhVZKRRGLgAmCqgZzgON8NJOGg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hao Luo <haoluo@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, bpf <bpf@vger.kernel.org>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>



On 3/22/22 2:37 PM, Hao Luo wrote:
> On Tue, Mar 22, 2022 at 11:09 AM Yonghong Song <yhs@fb.com> wrote:
>>
>> Hi, Yosry, I heard this was discussed in bpf office hour which I
>> didn't attend. Could you summarize the conclusion and what is the
>> step forward? We also have an internal tool which collects cgroup
>> stats and this might help us as well. Thanks!
>>
> 
> Hi Yonghong,
> 
> Yosry is out of office this entire week. I don't know whether he has
> access to corp email account, so please allow me to reply on his
> behalf.
> 
> So instead of using rstat in bpf (by providing a map interface), it's
> better to leverage the flexibility provided by bpf to extend rstat.
> "We can achieve a similar outcome with a less intrusive design." Yosry
> "will look at programs providing their own aggregators and maintaining
> their own stats, and only making callbacks to/from rstat." As the next
> step, Yosry is going to work on an RFC patchset to drive the
> discussion, when he is back.
> 
> It's great to see that this is helpful to you as well! I am looking
> forward to collaboration if there is a need.

Thanks, Hao, for explanation. I am looking forward to the RFC patch!

> 
> Hao
