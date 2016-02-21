From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 21 Feb 2016 15:45:18 +0200
Message-ID: <20160221134518.GM30450@leon.nu>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
 <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
 <20160221074301.GK30450@leon.nu>
 <CAG53R5XGJESb+_-FtjLsK+jHoEmbePLd==G2knBMOcrfdPm62Q@mail.gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leon-nu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        bh=B7W+P1eSuqf6/MZIMjJ9qobNIAtVTdZGM1/48pZQ2pM=;
        b=edTo1qWWrUE9R6BdvH7+/3Zn27euAsnk5NSW7aKOY+LzDcCBMgTQGHzXmHHo46jGcz
         pXEbO+BGNMnjP82pUlYUUyf/ZO9/VsHz7zidCRj72yo6/RFu18Ewbg3P06aDD8Sz0S9Y
         Nquxq9AARhkan7icXb97osmqs0P7tQisJW1L7wZKJBUo/Vfl7e4aUtwR1LPEvv1c05Gn
         fv9dJzEKxKvwKWoYvDRf7JJivmBbYwSBBNjjYopwJ4lABUcs5r3GNrSQOylmfNdtub7v
         MymglcUP04cKNjPAOWuMVKirsbiPgjVeBB3GsBmB+8fwhH3vOV16yzQWDlKHq981Dt4E
         B/PA==
Content-Disposition: inline
In-Reply-To: <CAG53R5XGJESb+_-FtjLsK+jHoEmbePLd==G2knBMOcrfdPm62Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Feb 21, 2016 at 05:03:05PM +0530, Parav Pandit wrote:
> On Sun, Feb 21, 2016 at 1:13 PM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> > On Sat, Feb 20, 2016 at 04:30:04PM +0530, Parav Pandit wrote:
> > Can you place this ifdef before declaring struct rdma_cgroup?
> Yes. I missed out this cleanup. Done locally now.

Great, additional thing which spotted my attention was related to
declaring and using the new cgroups functions. There are number of
places where you protected the calls by specific ifdefs in the
IB/core c-files and not in h-files as it is usually done.

> 
> > Thanks
