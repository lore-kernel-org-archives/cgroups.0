From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling errors
 (series 2)
Date: Thu, 02 Feb 2023 11:09:04 -0700
Message-ID: <875yckvt1b.fsf@meer.lwn.net>
References: <20230129231053.20863-1-rdunlap@infradead.org>
Mime-Version: 1.0
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 48D347DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1675361345; bh=2+a4mZYwqT3vzf0UQzfkcA5CdDxOuo7YvzN9jr8nkig=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gY7ULbf3et5D4Qc/CNx/w7sCxqXxX6fR0sNacSV7nefpdle702hp6si3iizN6qwiE
         uEIY7Q78a9h2RN4xfonCmMXE/H1WHGv23zZbRY3a8TD9z3xCs5/ly7iH92i4XVhMfk
         m1+3SrM+pmOm5qUcXvYL8szbXDpSICOPir4Ff+tNZ80bHoZS0uhfOu3aabBosNVFfP
         7pgupe9C5u4Sz6v8uZtM64S9OiXXXwx07OTa5szwYHdV6XxaRnf+mq/MpKQwaSbzh0
         jfCb5rfx6sWATpmne99lGmlwL/b8o+ggGmLTspO1j2VtBWLoL4M3uxU9erIgFeIYC3
         b3TsgnsFP3UgQ==
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Jean Delvare <jdelvare@suse.com>, Guenter Roeck <linux@roeck-us.net>, l

Randy Dunlap <rdunlap@infradead.org> writes:

> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
>
> These patches are based on linux-next-20230127.

So I've applied a bunch of these

>  [PATCH 1/9] Documentation: admin-guide: correct spelling
>  [PATCH 2/9] Documentation: driver-api: correct spelling

applied

>  [PATCH 3/9] Documentation: hwmon: correct spelling
>  [PATCH 4/9] Documentation: networking: correct spelling
>  [PATCH 5/9] Documentation: RCU: correct spelling

These have been taken up elsewhere

>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling

I've left these for the SCSI folks for now.  Do we *really* want to be
fixing spelling in ChangeLog files from almost 20 years ago?

>  [PATCH 8/9] Documentation: sparc: correct spelling
>  [PATCH 9/9] Documentation: userspace-api: correct spelling

Applied.

Thanks,

jon
