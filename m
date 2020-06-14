From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] Fix code style in css_task_iter_next_css_set()
Date: Sun, 14 Jun 2020 09:13:35 +0200
Message-ID: <20200614071335.GB2629255@kroah.com>
References: <52681580-7ab4-a73c-6c86-bc9872de4fe8@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592118818;
        bh=G0YkOo/zB1bFhEFNAvhbmUwDkAVvzsSd01JJOtcdihM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=absDd/JLqierYmu1LqtPo2LMI7JuTj4umdM9bXqwxtxIUU8GXB1zS18t9qaydSz4p
         AmW3AgUxqPir6IBaoUHFlVbmi4L6GtaacX8QkTK64jO0PBj9aCiYbg6wM2aWHGjuED
         KhOLrZVrEBSfcHFjKPWBQLntZ+wQYWYfXQab+2E8=
Content-Disposition: inline
In-Reply-To: <52681580-7ab4-a73c-6c86-bc9872de4fe8-S0/GAf8tV78@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Markus Elfring <Markus.Elfring-S0/GAf8tV78@public.gmane.org>
Cc: weifenghai <zzuedu2000-9Onoh4P/yGk@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Fri, Jun 12, 2020 at 09:56:26PM +0200, Markus Elfring wrote:
> > One line similar code before in this function
> 
> I suggest to improve the commit message.
> How do you think about a wording variant like the following?
> 
>    Combine two assignments for the variable “l” into one statement.
> 
> Regards,
> Markus

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
