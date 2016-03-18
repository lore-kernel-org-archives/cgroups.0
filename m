From: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-linus 2/2] writeback, cgroup: fix use of the wrong
 bdi_writeback which mismatches the inode
Date: Fri, 18 Mar 2016 16:33:26 -0700
Message-ID: <CAAeU0aPuSDtevo+38NkG2mBo0e0tkyAeK2hMq_yYiPTaizYJ9g@mail.gmail.com>
References: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg@mail.gmail.com>
	<20160318175003.GA20028@mtj.duckdns.org>
	<20160318175204.GB20028@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=XB2zPWuVxUfAFtietEKVI7Fnmie2IlvY/cOmopt9lwM=;
        b=kKbXyPI46IYjT7ISVqL7cd/1A7VtD/NhgfFym/kKB8UZdeVLZ7gSUbOjm2Vgnz50xB
         VbNg4yXkZRez7tsQFCHoXegSngyMVYBnxIdre0UZ/iFHigmCncKG9PUy2YScNbxubWig
         h6l924eYR0+frzx/5isyny8tVapnOs5sauly2Q/ip2052oiQqSCEDKjomgVHW12XxI3Y
         z6prQgNH1wGDKzEfcZ0tA5p+ZS38Rt7JPpex7mp9uypxKf9Cmq3i6CugPi/wEGEpvZeq
         njtA4ySMChUrPJOIXVnb13/IKIY+JOn8Hxx2Y8CjNiKw+IGgBskVOVE6or+dJb0DybDN
         2E+g==
In-Reply-To: <20160318175204.GB20028-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Mar 18, 2016 at 10:52 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Tahsin, I could reproduce the bug and this fixes it for me but it'd be
> great if you can verify the fix too.
>

Hi Tejun,
I verified that your patch fixes the problem.

Thanks a lot!
