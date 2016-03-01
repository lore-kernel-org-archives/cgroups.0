From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv7 2/3] IB/core: added support to use rdma cgroup controller
Date: Tue, 1 Mar 2016 14:53:31 +0530
Message-ID: <CAG53R5V-o9OC9Vvr-KQREYMGQwee27KqtEPdK6-DtPXcKJ4zXg@mail.gmail.com>
References: <1456668821-25799-1-git-send-email-pandit.parav@gmail.com>
	<1456668821-25799-3-git-send-email-pandit.parav@gmail.com>
	<56D55C06.8090102@mellanox.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=OBpzx+prgkU/Z9Q+vPNvvx4wlOJS6PUjc/DMjy4NaGY=;
        b=cjEbzsp5o8KkKtZY+iZ7C3jNyPkAL8THWyEPaoHBunlxeFNE3C+chLwBeKiG0sw2lZ
         7tqkXbp9+S8MuA3yt/dxn9TxiDlUhiipKBms5beOOJg5bnLknZYR4cu8CKojtM4pHni4
         OwuyCRf9dNNfDxnvwkknAlSvY0JlwwnZMWLL/3v59MAkLdO9oxA/zMa3LGhZ1vgOzvFf
         rmBcuKnCkjgcmmTqCfpysvZvK3uPBmoccthkbINxXHdPvAsqcX4tI0eOVJIpkL5b5/7Z
         xPotAiTri4W9Vul15UPD8wbaGCEBKXgElT5V62fCgfeUanFs0X+VgKZS/xy8Fnp5sYhY
         C0xA==
In-Reply-To: <56D55C06.8090102-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 1, 2016 at 2:38 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 28/02/2016 16:13, Parav Pandit wrote:
>> +void ib_rdmacg_query_limit(struct ib_device *device, int *limits, int max_count)
>> +{
>> +     rdmacg_query_limit(&device->cg_device, limits);
>> +}
>> +EXPORT_SYMBOL(ib_rdmacg_query_limit);
>
> You can remove the max_count parameter here as well.

ok.
