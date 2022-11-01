From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: clarification about misc controller and capacity vs. max
Date: Tue, 1 Nov 2022 07:35:42 -1000
Message-ID: <Y2FY7pVKWQgDE2Gk@slm.duckdns.org>
References: <2f7b7d6b10bdcbc9a73ea449d3636575124afa25.camel@intel.com>
 <Y2FPSqOaQGnISvXu@slm.duckdns.org>
 <14c21f13ebbcdbd0ea4f75b7fff790b31a05a5aa.camel@intel.com>
 <Y2FR6SYazbxyK5nj@slm.duckdns.org>
 <f678f325b47ac64e101c0ccea54c1cd1c4ea4206.camel@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SZOlmrIU3zPJm8I8RxpQWnf+DIcXmvWnjdo0U6pMluk=;
        b=llxNgOh5raFgOVdU0BfM5xVW8e3SqWPzVhi+AOt9T2XEOLOGBiIc2jTNpUvujTZXlC
         Hixqz8VU5pqwE0yuovTSYrf+0XoNzjSYI5OuN5NhYwGKcmFuAdTpfOBR5vTjMjFe1QFe
         WbdDYlfcFrBT3CYLwUWLMdJq6UmvKybwwvu6B5F6JpY1myK6PETXeQs8LkmMPgXL55ju
         DHjUqzG2H8Q8UqfR45/lXsV4BGnOzl9VRgrDL7JZrpRVSkImFUZgcEUVl2qhR63HOXol
         h3gTfHzWGCeNMbJ67/5d1Yg+rvH9dkKsCNeMHDQoGfUtkKytgF7XzKNkAsWzP0MfGHM9
         TIow==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f678f325b47ac64e101c0ccea54c1cd1c4ea4206.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Accardi, Kristen C" <kristen.c.accardi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Nov 01, 2022 at 05:11:13PM +0000, Accardi, Kristen C wrote:
> This is a bit of a deal breaker for the use of the misc controller for
> SGX EPC memory - we allow overcommit of the physical EPC memory as we
> have backing RAM that is used to swap. Would you be amenable to having
> a flag to ignore the total capacity value and allow for overcommit of
> the resource? If not I feel like we don't have a choice but to create a
> new controller.

Yeah, for sure. Maybe just introduce a special value (prolly u64 max) that
says that there's no limit. Or maybe just set it to total physical memory?

Thanks.

-- 
tejun
