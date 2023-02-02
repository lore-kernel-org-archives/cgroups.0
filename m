From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
Date: Thu, 02 Feb 2023 11:46:54 -0700
Message-ID: <87o7qbvra9.fsf@meer.lwn.net>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
 <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
 <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A8666739
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1675363615; bh=LWxEU72zl68liFRHK4qAaq/94gJ5U5MPeKaaBgQ+tzQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=IluSlawEh1lqfD3VE0Kr0lf7AKU/1bsSpHf52ekCzPrJkyCmWEesOx8n/34iWHP1l
         YD6uRTgtbiEoHnDflnOcd8eq+mn9Zn15QuGp5+ldYfwirT8bYSUtM7ZIcF3jyllkhj
         M+MnpPLKVT1BvMPHS66IlPs6NRg02abR7lsUptRqLdHVwbeynKQFpd8BBcH/vtII6Q
         LmA0cxt3YulQtJZ+Cun0ZxE0YMAy7/yWq2Z1kr0HTa/FZuk6yWVcv208QpTU9nFFpY
         4VpgeQhgD3zIAIfVS7Q5LBHM6BfRyr3e67CdEoQ7rkJ00JLai/QvRb7zJDsh4QSj6W
         nCzlihE+cuqeA==
In-Reply-To: <8540c721-6bb9-3542-d9bd-940b59d3a7a4-HInyCGIudOg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: nvdimm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neeraj Upadhyay <quic_neeraju-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jean Delvare <jdelvare-IBi9RG/b67k@public.gmane.org>, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Snitzer <snitzer-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, linux-raid-u79uwXL29TZNg+MwTxZMZA@public.gmane.org

Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> writes:

> On 2/2/23 10:33, Randy Dunlap wrote:
>> On 2/2/23 10:09, Jonathan Corbet wrote:
>>> Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:
>>>>   [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>>>   [PATCH 7/9] Documentation: scsi: correct spelling
>>>
>>> I've left these for the SCSI folks for now.  Do we *really* want to be
>>> fixing spelling in ChangeLog files from almost 20 years ago?
>> 
>> That's why I made it a separate patch -- so the SCSI folks can decide that...
>
> How about removing the Documentation/scsi/ChangeLog.* files? I'm not 
> sure these changelogs are still useful since these duplicate information 
> that is already available in the output of git log ${driver_directory}.

Actually, the information in those files mostly predates the git era, so
you won't find it that way.  I *still* question their value, though...

jon
