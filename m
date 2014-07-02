From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroups: Resource controller for open files.
Date: Wed, 2 Jul 2014 11:02:34 -0400
Message-ID: <20140702150234.GD23275@htj.dyndns.org>
References: <1404311407-4851-1-git-send-email-merimus@google.com>
 <20140702143300.GB23275@htj.dyndns.org>
 <CAANmLtwwbKBi+zZ01ywbeMnzu5a0UvqEz-_zHJLNtBVso2=ibg@mail.gmail.com>
 <20140702144901.GC23275@htj.dyndns.org>
 <CAANmLtwQkwrfQK0QK5LZSGqw7Z2+L-CSC_5TuSko1QtYo8WFfQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=luXj7cp9H6Ue4Spq1WvfHshuw3Ws67WIhPBcA3Pw+NQ=;
        b=K+PIc+XdMP0y6UgJb2DzIdlikeeDJ6lhu+25Nf8x4ue1BRljmEJ+tHX7shbaGsP2WD
         RR1psydHL4bwW8ee1d9Nr8R4uNbrAzc74zi8PnMpSW3C1ZVs2WKb6283z3Q97D1OoM1D
         g13z+vDZfSD9M0YlB4IxBVSwC0SFyKo+J1fEvbIbUDh/9VhtvXhHkCJ4JQqtfSahIi2a
         7x9TFS8wzmfX2IDCtBcHomQCQi+u3nOQTu1U2h/xDkKkI1MnGyqNpNcc40CsN7L1DL+J
         tfZ5N9s2fEtankyFZYuPtIcyUXB9IQOQZWajmUcMZzP62yGwjF2tylhalqmZCMv2rHBY
         Zc6g==
Content-Disposition: inline
In-Reply-To: <CAANmLtwQkwrfQK0QK5LZSGqw7Z2+L-CSC_5TuSko1QtYo8WFfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Binder Makin <merimus-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jacobowitz <dmj-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 02, 2014 at 10:55:01AM -0400, Binder Makin wrote:
> It does allow processes which are used to handling file handled to deal
> with the situation more cleanly.
> If you get the ENOMEM then you are out of memory and you kill the process,
> but if you are out of file handles we can clean up the open handles and
> continue.

I don't know.  If the program can manage fds dynamically, it may as
well police itself under a sensible limit.  I get that programs which
already work with EMFILE may benefit from this but this isn't adding
any essential feature and the same goal can be trivially achieved
without any help from kernel as the benefits from EMFILE handling
assumes the program is well-behaving.  I'm very doubtful that
custom-fitting kernel behavior to specific and rather peculiar program
behaviors is a healthy approach.

Thanks.

-- 
tejun
