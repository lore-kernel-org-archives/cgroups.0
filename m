From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv7 2/3] IB/core: added support to use rdma cgroup
 controller
Date: Tue, 1 Mar 2016 13:06:52 +0200
Message-ID: <56D577CC.1070107@mellanox.com>
References: <1456668821-25799-1-git-send-email-pandit.parav@gmail.com>
 <1456668821-25799-3-git-send-email-pandit.parav@gmail.com>
 <56D55CE6.7030103@mellanox.com>
 <CAG53R5UrM7WAuamCEynDRKV0YMJsJUe=SEYfTrueQD0rtx71bA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mJ1MevPUBvjAsGfCzRvZVOya5EHLkERpYo4IMOqDmHE=;
 b=pYq07Xu2dQ3maw73QDywONP2BitMvh9b2cSzLUrhP8E3Ef7x9WVkeqihZWgJRqUWf7Q02Yhn+vMw3cObmrCFLN+fmVyaKq14bPSanmjzxUwgpl8VXlfu39ZgIWhTu9DjDYvVPsd5E0g2WNsqhqjABrNn1aRD/g49UQBLiDGjBh4=
In-Reply-To: <CAG53R5UrM7WAuamCEynDRKV0YMJsJUe=SEYfTrueQD0rtx71bA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 01/03/2016 11:22, Parav Pandit wrote:
> On Tue, Mar 1, 2016 at 2:42 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> On 28/02/2016 16:13, Parav Pandit wrote:
>>> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
>>> index 00da80e..54ea8ce 100644
>>> --- a/drivers/infiniband/core/device.c
>>> +++ b/drivers/infiniband/core/device.c
>>> @@ -343,28 +343,38 @@ int ib_register_device(struct ib_device *device,
>>>
>>>       ret = read_port_immutable(device);
>>>       if (ret) {
>>> -             printk(KERN_WARNING "Couldn't create per port immutable data %s\n",
>>> -                    device->name);
>>> +             pr_warn("Couldn't create per port immutable data %s\n",
>>> +                     device->name);
>>>               goto out;
>>
>> This change doesn't belong in the patch.
> I agree, but few warnings are with pr_warn and few with printk just
> make code look uneven.
> So I changed printk to pr_warn in same function instead of spinning
> complete new patch.
Still, I think it would be better to have such cosmetic changes in a
separate patch, so that we have a cleaner git history. You can send 
this extra patch separately from this patchset so that Doug can take 
it independently.
