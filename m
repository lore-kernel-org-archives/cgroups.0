From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 21 Sep 2016 10:13:38 +0530
Message-ID: <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
References: <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de> <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de> <20160911143522.GL6415@leon.nu>
 <20160911171409.GA13442@obsidianresearch.com> <20160911172445.GA25953@lst.de>
 <20160911175235.GB13442@obsidianresearch.com> <20160912050717.GE8812@leon.nu>
 <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com> <20160915185629.GF26069@leon.nu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=vsdkbs6Xh3T5VEnYxTzYAgit0E2feVgRfQPJQNrIkoA=;
        b=fTLy/fKIDrxkaQH+dYLDTQ0LIUcnJm0YiuwB8FDpmwUqh/6fh62IzEHF1CZktTLd5s
         vhWRNunV+bjrlydhxPmOghqezQVTlQ6ALxuuqnvnsoxWmCUCczndmDWQqRARYlHcHdUt
         xzXHY/JUlnwa4UrQkDKYH+asDFlPoHOP/uycN4ckCRses9mSLcW+7wcW9pTZoTOnHhOX
         EF2zGV8GSOcMvKo7u0SXJMmHpIObiUk0cN7INmINVkyxIsTcx8maLZyqRXcSgb53Pyhs
         JB8ubGaUT5jBDzoA5dtW7NdBCQmB+uPF/FSwEZqQOeUUrwKsqXzOyMJikwrWBBDNNejx
         0xrw==
In-Reply-To: <20160915185629.GF26069@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, Matan Barak <matanb@mellanox.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

Hi Leon,

On Fri, Sep 16, 2016 at 12:26 AM, Leon Romanovsky <leon@kernel.org> wrote:
> On Wed, Sep 14, 2016 at 12:36:19PM +0530, Parav Pandit wrote:
>> Hi Dennis,
>>
>> Do you know how would HFI1 driver would work along with rdma cgroup?
>>
>> Hi Matan, Leon, Jason,
>> Apart from HFI1, is there any other concern?
>> Or Patch is good to go?
>
> I didn't review it yet :(.
> Sorry
>

We have completed review from Tejun, Christoph.
HFI driver folks also provided feedback for Intel drivers.
Matan's also doesn't have any more comments.

If possible, if you can also review, it will be helpful.

I have some more changes unrelated to cgroup in same files in both the git tree.
Pushing them now either results into merge conflict later on for
Doug/Tejun, or requires rebase and resending patch.
If you can review, we can avoid such rework.

>>
>> 4.8 dates are close by (2 weeks) and there are two git trees involved
>> (that might cause merge error to Linus) so if there are no issues, I
>> would like to make request to Doug to consider it for 4.8 early on.
>>
>> Parav
>>
>> On Mon, Sep 12, 2016 at 10:37 AM, Leon Romanovsky <leon@kernel.org> wrote:
>> > On Sun, Sep 11, 2016 at 11:52:35AM -0600, Jason Gunthorpe wrote:
>> >> On Sun, Sep 11, 2016 at 07:24:45PM +0200, Christoph Hellwig wrote:
>> >> > > > > I've posted some initial work toward a) a while ago, and once we
>> >> > >
>> >> > > Did it get merged? Do you have a pointer?
>> >> >
>> >> > http://www.spinics.net/lists/linux-rdma/msg31958.html
>> >>
>> >> Right, I remember that. Certainly the right direction
>> >>
>> >> > > However, everything under verbs is not straightforward. The files in
>> >> > > userspace are not copies...
>> >> > >
>> >> > > user:
>> >> > >
>> >> > > struct ibv_query_device {
>> >> > >        __u32 command;
>> >> > >        __u16 in_words;
>> >> > >        __u16 out_words;
>> >> > >        __u64 response;
>> >> > >        __u64 driver_data[0];
>> >> > > };
>> >> > >
>> >> > > kernel:
>> >> > >
>> >> > > struct ib_uverbs_query_device {
>> >> > >         __u64 response;
>> >> > >         __u64 driver_data[0];
>> >> > > };
>> >> >
>> >> > We'll obviously need different strutures for the libibvers API
>> >> > and the kernel interface in this case, and we'll need to figure out
>> >> > how to properly translate them.  I think a cast, plus compile time
>> >> > type checking ala BUILD_BUG_ON is the way to go.
>> >>
>> >> I'm not sure I follow, which would I cast?
>> >>
>> >> BUILD_BUG_ON(sizeof(ibv_query_device) == sizeof(ib_uverbs_cmd_hdr) +
>> >>              sizeof(ib_uverbs_query_device))
>> >>
>> >> ?
>> >>
>> >> > > I'm thinking the best way forward might be to use a script and
>> >> > > transform userspace into:
>> >> > >
>> >> > > struct ibv_query_device {
>> >> > >   struct ib_uverbs_cmd_hdr hdr;
>> >> > >   struct ib_uverbs_query_device cmd;
>> >> > > };
>> >> >
>> >> > That would break the users of the interface.
>> >>
>> >> Sorry, I mean doing this inside rdma-plumbing. Since the change is ABI
>> >> identical the modified libibverbs would still be binary compatible
>> >> with all providers but not source compatible. Since all kernel
>> >> supported providers are in rdma-plumbing we can add the '.cmd.' at the
>> >> same time.
>> >>
>> >> The kernel uapi header would stay the same.
>> >>
>> >> > However automatically generating the user ABI from the kernel one
>> >> > might still be a good idea in the long run.
>> >>
>> >> My preference would be to try and use the kernel headers directly.
>> >
>> > I thought the same, especially after realizing that they are almost
>> > copy/paste from the vendor *-abi.h files.
>> >
>> >>
>> >> Jason
