From: Hongchen Zhang <zhanghongchen@loongson.cn>
Subject: Re: [PATCH] cgroup: wait for css offline when rmdir
Date: Mon, 30 May 2022 09:53:51 +0800
Message-ID: <e74e03f1-cb54-b158-a085-2965fd088d1d@loongson.cn>
References: <1653619158-27607-1-git-send-email-zhanghongchen@loongson.cn>
 <YpCQZ5RRnxwh7fmK@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <YpCQZ5RRnxwh7fmK@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2022/5/27 下午4:48, Tejun Heo wrote:
> On Fri, May 27, 2022 at 10:39:18AM +0800, Hongchen Zhang wrote:
>> when remove a cgroup dir, make sure all the csses associated which
>> the cgroup are all offlined,so that we will be sure that the resources
>> allocated by the csses are all freed when rmdir exit successfully.
> 
> Offlining doesn't guarantee that resources are freed and there's no definite
> time limit on how long it'd take to free all resources. e.g. for memcg, if
> there isn't sufficient memory pressure, its page cache can remain
> indefinitely. Is there something practical you're trying to achieve?
> 
> Thanks.
> 
Hi Tejun,
   When I test the LTP's memcg_test_3 testcase at 8 Node server,I get 
the -ENOMEM error,which caused by no avaliable idr found in mem_cgroup_idr.
the reason is the use of idr in mem_cgroup_idr is too fast than the 
free.In the specific case,the idr is used and freed cyclically,so when 
we rmdir one cgroup dir, we can synchronize the idr free through wating 
for the memcg css offlined,and then we can use it the next cycle.

Thanks.

