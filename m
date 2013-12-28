From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH nf-next v3] netfilter: xtables: lightweight process control
 group matching
Date: Sat, 28 Dec 2013 09:17:58 +0100
Message-ID: <52BE8936.6000001@redhat.com>
References: <cover.1387815795.git.dborkman@redhat.com> <7d845623366ba0d435d5c82bf318455871929e90.1387815795.git.dborkman@redhat.com> <52BCF04B.3070908@huawei.com> <52BD34D1.1040708@redhat.com> <52BE2A79.6040504@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-owner@vger.kernel.org>
In-Reply-To: <52BE2A79.6040504@huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On 12/28/2013 02:33 AM, Li Zefan wrote:
> On 2013/12/27 16:05, Daniel Borkmann wrote:
>> On 12/27/2013 04:13 AM, Li Zefan wrote:
...
>>> I'd suggest splitting cls_cgroup code into 2 parts. The first part
>>> is to manage cgroupfs and classid, and should be put into net/core/
>>> and add a new config like NET_CGROUP_CLASSID for it. The second part
>>> is specific cls_cgroup code.
>>
>> Sure, if this is wished, I'd do this as a follow-up as it doesn't affect
>> any of this code in netfilter here.
> 
> We should clean up the code before introducing a new feature, not the
> other way.

Hehe, quite honestly, I think this is YOUR opinion of a "cleanup", which
makes the code actually more complicated, and it's not strictly needed.

If you are so desperate about this separation, fine, I will do this, but
again, I don't think it's *strictly* required for this.
