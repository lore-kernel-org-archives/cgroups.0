From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3.4 0/2] 2 bug fixes for the 3.4 cgroup code
Date: Wed, 9 Jan 2013 07:39:50 -0800
Message-ID: <20130109153950.GI3926@htj.dyndns.org>
References: <1357733486-1742-1-git-send-email-hdegoede@redhat.com>
 <20130109143850.GG3926@htj.dyndns.org>
 <50ED8347.7000806@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=QUI4HsCNxlGU6y2hj5Hgy6W166D/8NTGmNvJ9AjSDik=;
        b=dxrUVBeUUIA+Zupi4t9cNscPBnFHlFU6SHTiTROtZGBoOdBY5YuvUSv+MzjtAL84WC
         wtPeJ/J7Hl8TVehpKpRaBPFntGr+/pFmy2ctIEroHzimEEcB5mTdWW8Z2oepyBz5bpjS
         BNrL4lxGvw4ufpN4uzDHfOtn4D7AxLkXaAFj7i7edMJTHewpoR3sMDVmN/opU2kYAP1L
         GwJk3qG/3Etg6zye/Rv/xI6V+Dwam88XFZGCFh3xRtuWUdJvynAbeWACljukU1SpnsM2
         uShW2gUjb3O4VjMBNK4gp6AZDGIfZe3eCQttMK1tfUB42HvOveHMXj0GP667mPHmA/Ur
         mwcQ==
Content-Disposition: inline
In-Reply-To: <50ED8347.7000806-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jan 09, 2013 at 03:48:39PM +0100, Hans de Goede wrote:
> I know that that is the generic rule, but I was hoping Greg KH would be
> willing to make an exception. At least I can try :)
> 
> I've solved the panic btw, I'll send a v2 of the set right after this
> mail, including an explanation what was wrong with v1.
> 
> I was hoping that I could get a review from you on v2 including an
> Acked-by (assuming the review does not find any issues) before I very kindly
> ask Greg KH to make an exception for this.

Unfortunately, I'm fairly sure Greg won't take these.  It's simply not
how -stable process works, at least until now.  I'll try to review
them later.

Thanks.

-- 
tejun
