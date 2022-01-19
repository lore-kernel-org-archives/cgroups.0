From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC 4/6] dma-buf: Add DMA-BUF exporter op to charge a DMA-BUF to
 a cgroup.
Date: Wed, 19 Jan 2022 16:58:30 +0100
Message-ID: <5cc27a05-8131-ce9b-dea1-5c75e994216d__26172.898248636$1642607954$gmane$org@amd.com>
References: <20220115010622.3185921-1-hridya@google.com>
 <20220115010622.3185921-5-hridya@google.com>
 <f8c8b196-7d12-6242-97ac-38149f3a3ba3@amd.com>
 <CA+wgaPMjCfjQS4LA8hmVwAaGfXZhoJvvTUnOGt3duOhFb3orTw@mail.gmail.com>
 <Yeg0GGi0tdnnCLHg@phenom.ffwll.local>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4/YeMl2TEMpTeoo5r3iFsKRGITSfa4Dl/Y3WVvxr5o=;
 b=lFSRcNDzAU/WM1JIpxTGPJmH4n+kUYYFD45mWj2jVAfAe6s5UYdkodwksbBnauuQIWrIY9PJEDl6bDUmKaSE9dXutcmAkpKZfHx7ip1vV8pxOH2VPlEW14lCarLx9FZ+67r3XhOI8x5AClzAs+ZNpHIBn3DYRdu19ClGZQCRgmU=
In-Reply-To: <Yeg0GGi0tdnnCLHg-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Starkey-5wv7dgnIgG8@public.gmane.org>, John Stultz <john.stul>

Am 19.01.22 um 16:54 schrieb Daniel Vetter:
> On Tue, Jan 18, 2022 at 10:54:16AM -0800, Hridya Valsaraju wrote:
>> On Sun, Jan 16, 2022 at 11:46 PM Christian K=C3=B6nig
>> <christian.koenig-5C7GfCeVMHo@public.gmane.org> wrote:
>>> Am 15.01.22 um 02:06 schrieb Hridya Valsaraju:
>>>> The optional exporter op provides a way for processes to transfer
>>>> charge of a buffer to a different process. This is essential for the
>>>> cases where a central allocator process does allocations for various
>>>> subsystems, hands over the fd to the client who
>>>> requested the memory and drops all references to the allocated memory.
>>>>
>>>> Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.=
gmane.org>
>>>> ---
>>>>    include/linux/dma-buf.h | 18 ++++++++++++++++++
>>>>    1 file changed, 18 insertions(+)
>>>>
>>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>>>> index 7ab50076e7a6..d5e52f81cc6f 100644
>>>> --- a/include/linux/dma-buf.h
>>>> +++ b/include/linux/dma-buf.h
>>>> @@ -13,6 +13,7 @@
>>>>    #ifndef __DMA_BUF_H__
>>>>    #define __DMA_BUF_H__
>>>>
>>>> +#include <linux/cgroup_gpu.h>
>>>>    #include <linux/dma-buf-map.h>
>>>>    #include <linux/file.h>
>>>>    #include <linux/err.h>
>>>> @@ -285,6 +286,23 @@ struct dma_buf_ops {
>>>>
>>>>        int (*vmap)(struct dma_buf *dmabuf, struct dma_buf_map *map);
>>>>        void (*vunmap)(struct dma_buf *dmabuf, struct dma_buf_map *map);
>>>> +
>>>> +     /**
>>>> +      * @charge_to_cgroup:
>>>> +      *
>>>> +      * This is called by an exporter to charge a buffer to the speci=
fied
>>>> +      * cgroup.
>>> Well that sentence makes absolutely no sense at all.
>>>
>>> The dma_buf_ops are supposed to be called by the DMA-buf subsystem on
>>> behalves of the importer and never by the exporter itself.
>>>
>>> I hope that this is just a documentation mixup.
>> Thank you for taking a look Christian!
>>
>> Yes, that was poor wording, sorry about that. It should instead say
>> that the op would be called by the process the buffer is currently
>> charged to in order to transfer the buffer's charge to a different
>> cgroup. This is helpful in the case where a process acts as an
>> allocator for multiple client processes and we would like the
>> allocated buffers to be charged to the clients who requested their
>> allocation(instead of the allocating process as is the default
>> behavior). In Android, the graphics allocator HAL process[1] does
>> most of the graphics allocations on behalf of various clients. After
>> allocation, the HAL process passes the fd to the client over binder
>> IPC and the binder driver invokes the charge_to_cgroup() DMA-BUF op to
>> uncharge the buffer from the HAL process and charge it to the client
>> process instead.
>>
>> [1]: https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fsource.android.com%2Fdevices%2Fgraphics%2Farch-bq-gralloc&amp;data=3D04%7C=
01%7Cchristian.koenig%40amd.com%7C838d25da974d4ea4257508d9db63eb70%7C3dd896=
1fe4884e608e11a82d994e183d%7C0%7C0%7C637782044488604857%7CUnknown%7CTWFpbGZ=
sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3=
000&amp;sdata=3DQn7JeyF5Rq9tnrGw1KgNuQkpu5RbcrvPhDOa1OBJ6TU%3D&amp;reserved=
=3D0
> For that use-case, do we really need to have the vfunc abstraction and
> force all exporters to do something reasonable with it?

I was about to write up a similar answer, but more from the technical side.

Why in the world should that be done on the DMA-buf object as a=20
communication function between importer and exporter?

That design makes absolutely no sense at all to me.

Regards,
Christian.

>
> I think just storing the cgrpus gpu memory bucket this is charged against
> and doing this in a generic way would be a lot better.
>
> That way we can also easily add other neat features in the future, like
> e.g. ttm could take care of charge-assignement automatically maybe, or we
> could print the current cgroups charge relationship in the sysfs info
> file. Or anything else really.
>
> I do feel that in general for gpu memory cgroups to be useful, we should
> really have memory pools as a fairly strong concept. Otherwise every
> driver/allocator/thing is going to come up with their own, and very likely
> incompatible interpretation. And we end up with a supposed generic cgroups
> interface which cannot actually be used in a driver/vendor agnostic way at
> all.
> -Daniel
>
>> Regards,
>> Hridya
>>
>>
>>> Regards,
>>> Christian.
>>>
>>>>    The caller must hold a reference to @gpucg obtained via
>>>> +      * gpucg_get(). The DMA-BUF will be uncharged from the cgroup it=
 is
>>>> +      * currently charged to before being charged to @gpucg. The call=
er must
>>>> +      * belong to the cgroup the buffer is currently charged to.
>>>> +      *
>>>> +      * This callback is optional.
>>>> +      *
>>>> +      * Returns:
>>>> +      *
>>>> +      * 0 on success or negative error code on failure.
>>>> +      */
>>>> +     int (*charge_to_cgroup)(struct dma_buf *dmabuf, struct gpucg *gp=
ucg);
>>>>    };
>>>>
>>>>    /**

