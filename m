From: "taoyi.ty" <escape@linux.alibaba.com>
Subject: Re: [RFC PATCH 0/2] support cgroup pool in v1
Date: Fri, 10 Sep 2021 10:12:32 +0800
Message-ID: <7b8d68c6-9a1c-dc19-e430-e044e4c4f210@linux.alibaba.com>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <YTjmP0EGEWGYhroM@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <YTjmP0EGEWGYhroM@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, shanpeic@linux.alibaba.com

I am glad to receive your reply.

cgroup pool is a relatively simple solution that I think can

solve the problem.

I have tried making locking more granular, but in the end found

it too diffcult. cgroup_mutex protects almost all operation related

to cgroup. If not use cgroup_mutex, I have no idea how to design

lock mechanism to take both concurrent performance and

existing interfaces into account. Do you have any good advice?


thanks,


Yi Tao


On 2021/9/9 上午12:35, Tejun Heo wrote:
> Hello,
>
> On Wed, Sep 08, 2021 at 08:15:11PM +0800, Yi Tao wrote:
>> In order to solve this long-tail delay problem, we designed a cgroup
>> pool. The cgroup pool will create a certain number of cgroups in advance.
>> When a user creates a cgroup through the mkdir system call, a clean cgroup
>> can be quickly obtained from the pool. Cgroup pool draws on the idea of
>> cgroup rename. By creating pool and rename in advance, it reduces the
>> critical area of cgroup creation, and uses a spinlock different from
>> cgroup_mutex, which reduces scheduling overhead on the one hand, and eases
>> competition with attaching processes on the other hand.
> I'm not sure this is the right way to go about it. There are more
> conventional ways to improve scalability - making locking more granular and
> hunting down specific operations which take long time. I don't think cgroup
> management operations need the level of scalability which requires front
> caching.
>
> Thanks.
>
