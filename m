From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv7 2/3] IB/core: added support to use rdma cgroup controller
Date: Tue, 1 Mar 2016 14:52:15 +0530
Message-ID: <CAG53R5UrM7WAuamCEynDRKV0YMJsJUe=SEYfTrueQD0rtx71bA@mail.gmail.com>
References: <1456668821-25799-1-git-send-email-pandit.parav@gmail.com>
	<1456668821-25799-3-git-send-email-pandit.parav@gmail.com>
	<56D55CE6.7030103@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=HM6F1YXlQV2cJszHGWdZPcQg925EDQskagHnVM+FDn4=;
        b=CGJl/mh1lXP90NGvqE0UPsjF0ELqLB/OMh8DSaM95vg6KkW+ecFvSWAAOAafoaAtRe
         dMMt0oDIUKzbBak/dxQYLBDhmNSPS9M1OhNJLJ7dHAE/tGpWsqW3CuV8F0hXZUC4v4/c
         TE8eOv7zPvFDxDCGnQbBdvhvTVZ9zQ4IOLAweQht+DGgcFka7Q6X/BMS2+TlDsJbKdo4
         5Hia+sFAJFcd8x30fnH6eEHiW6eWMMMMCHw/7omrSlltD00x6Tx5/A61bja0fnOIryxy
         5s8V6Hrwv5nCKVtQ+KRPv0KGr2ymgHHTr70RkOxvK+N5z+BmEsqcdnZTW2tUpbjSWiep
         JS+g==
In-Reply-To: <56D55CE6.7030103@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Tue, Mar 1, 2016 at 2:42 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 28/02/2016 16:13, Parav Pandit wrote:
>> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
>> index 00da80e..54ea8ce 100644
>> --- a/drivers/infiniband/core/device.c
>> +++ b/drivers/infiniband/core/device.c
>> @@ -343,28 +343,38 @@ int ib_register_device(struct ib_device *device,
>>
>>       ret = read_port_immutable(device);
>>       if (ret) {
>> -             printk(KERN_WARNING "Couldn't create per port immutable data %s\n",
>> -                    device->name);
>> +             pr_warn("Couldn't create per port immutable data %s\n",
>> +                     device->name);
>>               goto out;
>
> This change doesn't belong in the patch.
I agree, but few warnings are with pr_warn and few with printk just
make code look uneven.
So I changed printk to pr_warn in same function instead of spinning
complete new patch.
