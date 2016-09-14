From: Matan Barak <matanb@mellanox.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 14 Sep 2016 11:14:03 +0300
Message-ID: <13a00119-e629-2d34-d08b-c02bb6beceea@mellanox.com>
References: <20160901084406.GA4115@lst.de>
 <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de> <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de> <20160911143522.GL6415@leon.nu>
 <20160911171409.GA13442@obsidianresearch.com> <20160911172445.GA25953@lst.de>
 <20160911175235.GB13442@obsidianresearch.com> <20160912050717.GE8812@leon.nu>
 <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YlpXV3mSOpo9dw0NJyd4LjiNo8O+4hB6A4DMzMiQE58=;
 b=lPaxZFsqhTGfTxVv+yfAjZA6iSx91D+J9lXeaVKMaDHI2F4/PHp7h+1CObdGMwg1JdWdCG5+/Zy0G/CBKJhkZgnojgWLWyHubI8hz7muil8ab0nm8EE4nT19KWHRcv71fAYk0DT8PJRzZuVPWGRCNnvh0OuFOrxjH5ldY0gQvdM=
In-Reply-To: <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Parav Pandit <pandit.parav@gmail.com>, Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On 14/09/2016 10:06, Parav Pandit wrote:
> Hi Dennis,
>
> Do you know how would HFI1 driver would work along with rdma cgroup?
>
> Hi Matan, Leon, Jason,
> Apart from HFI1, is there any other concern?

I just wonder how things like RSS will work. For example, a RSS QP 
doesn't really have a queue (if I recall, it's connected to work queues 
via an indirection table). So, when a user creates such a QP, do you 
want to account it as a regular QP?
How are work queues accounted?


> Or Patch is good to go?
>
> 4.8 dates are close by (2 weeks) and there are two git trees involved
> (that might cause merge error to Linus) so if there are no issues, I
> would like to make request to Doug to consider it for 4.8 early on.
>
> Parav
>
> On Mon, Sep 12, 2016 at 10:37 AM, Leon Romanovsky <leon@kernel.org> wrote:
>> On Sun, Sep 11, 2016 at 11:52:35AM -0600, Jason Gunthorpe wrote:
>>> On Sun, Sep 11, 2016 at 07:24:45PM +0200, Christoph Hellwig wrote:
>>>>>>> I've posted some initial work toward a) a while ago, and once we
>>>>>
>>>>> Did it get merged? Do you have a pointer?
>>>>
>>>> http://www.spinics.net/lists/linux-rdma/msg31958.html
>>>
>>> Right, I remember that. Certainly the right direction
>>>
>>>>> However, everything under verbs is not straightforward. The files in
>>>>> userspace are not copies...
>>>>>
>>>>> user:
>>>>>
>>>>> struct ibv_query_device {
>>>>>        __u32 command;
>>>>>        __u16 in_words;
>>>>>        __u16 out_words;
>>>>>        __u64 response;
>>>>>        __u64 driver_data[0];
>>>>> };
>>>>>
>>>>> kernel:
>>>>>
>>>>> struct ib_uverbs_query_device {
>>>>>         __u64 response;
>>>>>         __u64 driver_data[0];
>>>>> };
>>>>
>>>> We'll obviously need different strutures for the libibvers API
>>>> and the kernel interface in this case, and we'll need to figure out
>>>> how to properly translate them.  I think a cast, plus compile time
>>>> type checking ala BUILD_BUG_ON is the way to go.
>>>
>>> I'm not sure I follow, which would I cast?
>>>
>>> BUILD_BUG_ON(sizeof(ibv_query_device) == sizeof(ib_uverbs_cmd_hdr) +
>>>              sizeof(ib_uverbs_query_device))
>>>
>>> ?
>>>
>>>>> I'm thinking the best way forward might be to use a script and
>>>>> transform userspace into:
>>>>>
>>>>> struct ibv_query_device {
>>>>>   struct ib_uverbs_cmd_hdr hdr;
>>>>>   struct ib_uverbs_query_device cmd;
>>>>> };
>>>>
>>>> That would break the users of the interface.
>>>
>>> Sorry, I mean doing this inside rdma-plumbing. Since the change is ABI
>>> identical the modified libibverbs would still be binary compatible
>>> with all providers but not source compatible. Since all kernel
>>> supported providers are in rdma-plumbing we can add the '.cmd.' at the
>>> same time.
>>>
>>> The kernel uapi header would stay the same.
>>>
>>>> However automatically generating the user ABI from the kernel one
>>>> might still be a good idea in the long run.
>>>
>>> My preference would be to try and use the kernel headers directly.
>>
>> I thought the same, especially after realizing that they are almost
>> copy/paste from the vendor *-abi.h files.
>>
>>>
>>> Jason

