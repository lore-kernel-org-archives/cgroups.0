From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 14 Sep 2016 12:36:19 +0530
Message-ID: <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
References: <20160901084406.GA4115@lst.de> <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com> <20160910161442.GC29259@lst.de>
 <20160910170151.GA5230@obsidianresearch.com> <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu> <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de> <20160911175235.GB13442@obsidianresearch.com> <20160912050717.GE8812@leon.nu>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=6g9rPEfDgCByBOTTegM8KDB+K/RYdI3CLfuRWOU5ITQ=;
        b=WJ+80D8CilOXYVJMTLzF4caZTzyPuun3ypaTahhzqrFItkmJKZjjsqJMYtdtKqCKu4
         4e+JDfEnADwioQ2EdcLp7sDhJfzO04jssJWT1bhopWpv21L3I6lwHDyX2a+sYVpSM7vx
         x/PgReEZKm7HFYj5+trBWdFOV4OPLB1eQctfYlI/bYhoffbJc3u6qC7o9riLTN1H4Czm
         8gwFhqGX5ChcJK/wxbrcbxT0hmaolkwKTsLd8642keeEOb+iwqe3NqeCgUgQdz+EWR7m
         z+9AwIzssVYrZs7nX1EDCodUPI5vTjg+KBKAHAqg00cqmt7uZJ8+9GF8K5eThzocLF5Z
         Mt9w==
In-Reply-To: <20160912050717.GE8812-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dennis,

Do you know how would HFI1 driver would work along with rdma cgroup?

Hi Matan, Leon, Jason,
Apart from HFI1, is there any other concern?
Or Patch is good to go?

4.8 dates are close by (2 weeks) and there are two git trees involved
(that might cause merge error to Linus) so if there are no issues, I
would like to make request to Doug to consider it for 4.8 early on.

Parav

On Mon, Sep 12, 2016 at 10:37 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Sun, Sep 11, 2016 at 11:52:35AM -0600, Jason Gunthorpe wrote:
>> On Sun, Sep 11, 2016 at 07:24:45PM +0200, Christoph Hellwig wrote:
>> > > > > I've posted some initial work toward a) a while ago, and once we
>> > >
>> > > Did it get merged? Do you have a pointer?
>> >
>> > http://www.spinics.net/lists/linux-rdma/msg31958.html
>>
>> Right, I remember that. Certainly the right direction
>>
>> > > However, everything under verbs is not straightforward. The files in
>> > > userspace are not copies...
>> > >
>> > > user:
>> > >
>> > > struct ibv_query_device {
>> > >        __u32 command;
>> > >        __u16 in_words;
>> > >        __u16 out_words;
>> > >        __u64 response;
>> > >        __u64 driver_data[0];
>> > > };
>> > >
>> > > kernel:
>> > >
>> > > struct ib_uverbs_query_device {
>> > >         __u64 response;
>> > >         __u64 driver_data[0];
>> > > };
>> >
>> > We'll obviously need different strutures for the libibvers API
>> > and the kernel interface in this case, and we'll need to figure out
>> > how to properly translate them.  I think a cast, plus compile time
>> > type checking ala BUILD_BUG_ON is the way to go.
>>
>> I'm not sure I follow, which would I cast?
>>
>> BUILD_BUG_ON(sizeof(ibv_query_device) == sizeof(ib_uverbs_cmd_hdr) +
>>              sizeof(ib_uverbs_query_device))
>>
>> ?
>>
>> > > I'm thinking the best way forward might be to use a script and
>> > > transform userspace into:
>> > >
>> > > struct ibv_query_device {
>> > >   struct ib_uverbs_cmd_hdr hdr;
>> > >   struct ib_uverbs_query_device cmd;
>> > > };
>> >
>> > That would break the users of the interface.
>>
>> Sorry, I mean doing this inside rdma-plumbing. Since the change is ABI
>> identical the modified libibverbs would still be binary compatible
>> with all providers but not source compatible. Since all kernel
>> supported providers are in rdma-plumbing we can add the '.cmd.' at the
>> same time.
>>
>> The kernel uapi header would stay the same.
>>
>> > However automatically generating the user ABI from the kernel one
>> > might still be a good idea in the long run.
>>
>> My preference would be to try and use the kernel headers directly.
>
> I thought the same, especially after realizing that they are almost
> copy/paste from the vendor *-abi.h files.
>
>>
>> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
