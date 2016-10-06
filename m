From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 6 Oct 2016 18:29:54 +0530
Message-ID: <CAG53R5UyDvXL5-UZo_jMjfdEBV+oWCdfBiebjLacvDSfYqC3aA@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com> <20161005112206.GC9282@leon.nu>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ZEcumkTHnMJQ+qDKXvMgg0l6CLF0gx6DtmmR4U5pAbU=;
        b=CV+modfT53cY14JqPhauZxC1EEEvyB4qOYRcVDYrXZhSYT+oHAcy8Edc2XXzx2Bupc
         mdX2i2aV3OybHRd6444v4TBl9IswZbqqMZrepNIqeX6vJi1VldPe89UbcrexWg9k1kTP
         Qc4BiiTXN7mdQUzxamcTUELna06e7pz8E12Ql0ZkBJWP67sAvztrt/YCw0jeVvzbzBbA
         zoPZizsi76iZI6qCSXZQfLeh15//I2ZEm1BI8pDKAGcWR2VMkKK+MpFQHo2TluqYtdhu
         D6R3zx/8LSWdaFb3fwOtti4CEyPoqeCVAiyoPEIqYExXqiUyHBvVG5efk6MMMlB1asdr
         dtqw==
In-Reply-To: <20161005112206.GC9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Leon,

On Wed, Oct 5, 2016 at 4:52 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Aug 31, 2016 at 02:07:24PM +0530, Parav Pandit wrote:
>> rdmacg: IB/core: rdma controller support
>>
>> Patch is generated and tested against below Doug's linux-rdma
>> git tree.
>>
>> URL: git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
>> Branch: master
>>
>> Patchset is also compiled and tested against below Tejun's cgroup tree
>> using cgroup v2 mode.
>> URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
>> Branch: master
>>
>> Overview:
>> Currently user space applications can easily take away all the rdma
>> device specific resources such as AH, CQ, QP, MR etc. Due to which other
>> applications in other cgroup or kernel space ULPs may not even get chance
>> to allocate any rdma resources. This results into service unavailibility.
>>
>> RDMA cgroup addresses this issue by allowing resource accounting,
>> limit enforcement on per cgroup, per rdma device basis.
>>
>> RDMA uverbs layer will enforce limits on well defined RDMA verb
>> resources without any HCA vendor device driver involvement.
>>
>> RDMA uverbs layer will not do limit enforcement of HCA hw vendor
>> specific resources. Instead rdma cgroup provides set of APIs
>> through which vendor specific drivers can do resource accounting
>> by making use of rdma cgroup.
>
> Hi Parav,
> I want to propose an extension to the RDMA cgroup which can be done as
> follow-up patches.
>

To bring logical end to this feature/patch discussion and to progress
towards merging it, Lets discuss this new feature in follow-on email
right after this email between these two mailing list and I will drop
linux kernel and docs mailing list.

> Let's add new global type, which will control whole HCA (for example in percentages). It will
> allow natively define new objects without need to introduce them to the user.
>
> This HCA share will be overwritten by specific UVERBS types which you
> already defined.
>
> What do you think?
>
> Except this proposal,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks a lot for review.

Parav
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
