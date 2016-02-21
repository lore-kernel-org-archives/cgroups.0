From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 21 Feb 2016 19:41:08 +0530
Message-ID: <CAG53R5U53sDQAURaWVeYmhnQSe+ncj+KWHdpOwbnrhE+OLVnMw@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
	<20160221074301.GK30450@leon.nu>
	<CAG53R5XGJESb+_-FtjLsK+jHoEmbePLd==G2knBMOcrfdPm62Q@mail.gmail.com>
	<20160221134518.GM30450@leon.nu>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to;
        bh=Lk26KQrSlpvxhFmfcGLpqc2vRsa38/8Tl5SSFUYJ5pc=;
        b=KLKTNZorPytmkQ1vTrtxkaD4F1L+9yuSrjzLxz7Lw4oiKR+vr3LZ+ec20nnxmWaoDu
         yZF7uA1eWhF+Im7n8oWp85I4wbOAlD/OFQ3cBcNqbuXvbwPNeFA+oQ9bCzj4ATPe9qNK
         +76/BwO6XbOaltemtzXOGx6E9KcHF1hRYIHANTdD3YUPNkx4ySiLMTbMv0AHT+EdlSGn
         EuxgguZKZtNKyARilREph/MqP4ZUDX8HRvgp37580pkFatqGCqMfBit/mlHaKoT47h4n
         lkwyQ+eRSUdm/QmPfjtas3d8gNZLU076cvomsGDv5VNuL8sfPu/WkjxIP+jA4oKgeKSb
         /DfA==
In-Reply-To: <20160221134518.GM30450-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: leon-2ukJVAZIZ/Y@public.gmane.org, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

CONFIG_CGROUP_RDMA

On Sun, Feb 21, 2016 at 7:15 PM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Sun, Feb 21, 2016 at 05:03:05PM +0530, Parav Pandit wrote:
>> On Sun, Feb 21, 2016 at 1:13 PM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
>> > On Sat, Feb 20, 2016 at 04:30:04PM +0530, Parav Pandit wrote:
>> > Can you place this ifdef before declaring struct rdma_cgroup?
>> Yes. I missed out this cleanup. Done locally now.
>
> Great, additional thing which spotted my attention was related to
> declaring and using the new cgroups functions. There are number of
> places where you protected the calls by specific ifdefs in the
> IB/core c-files and not in h-files as it is usually done.
>
ib_device_register_rdmacg, ib_device_unregister_rdmacg are the only
two functions called from IB/core as its tied to functionality.
They can also be implemented as NULL call when CONFIG_CGROUP_RDMA is undefined.
(Similar to ib_rdmacg_try_charge and others).
I didn't do because occurrence of call of register and unregister is
limited to single file and only twice compare to charge/uncharge
functions.
Either way is fine with me, I can make the changes which you
described. Let me know.

>>
>> > Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
