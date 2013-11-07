From: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Process Limit cgroups
Date: Thu, 7 Nov 2013 18:40:38 +0100
Message-ID: <CAJ75kXYnqoRphA7BMYuCJSSe5Tr_KM+hc_x2BYWFRYs17NWaiw@mail.gmail.com>
References: <trinity-a0dd51e0-7bb0-487f-a76b-aa2ba86877da-1383823917957@3capp-gmx-bs50>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        bh=56y7uVLqZTQnPDESnHMTFJBy6J2DT2YdC7ZraalKrEI=;
        b=nJAtUvWSd91w3mNRKH6nCv+p9ewmHsQ+3KQaeWhz3xlCEaNvexDRfw/wD6yxovdiSB
         LAqXxaut5KeaGPkTQGJ8c2RC6E2N5OUWREDUkvbJPPmOq6atjKhRjtRNs/s2lvDlUHhn
         Tlce5MG92R59sItU8gaRjPwhgtttO6bqkUDGtqAkr1GUAts48KTPYxZxQ1WSzOgEU6rb
         kQiM4uQuiuiO2rZ3IAD8sX8WM15DXb1nPHSStNHNbvxnaYnONeW36GPzZP3N6Xk2rC61
         BND01dNZ+DaGSQbwVZrLHpSLgf0o0KnS7ioWvJASsN+8UF0B9DWUd3vwBO7/IUThPsKD
         LN0w==
In-Reply-To: <trinity-a0dd51e0-7bb0-487f-a76b-aa2ba86877da-1383823917957@3capp-gmx-bs50>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Robert Gierzinger <robert.gierzinger-RbZlAiThDcE@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 7, 2013 at 12:31 PM, Robert Gierzinger
<robert.gierzinger-RbZlAiThDcE@public.gmane.org> wrote:
> Will there be a limitation of the number of processes per cgroup (task counter subsystem from Frederic Weisbecker)? I guess this would be interesting for many users especially in connection with LXC. As long as this is not implemented our security policy prevents us from using LXC. I could isolate resources quite well, however, I am still able to bomb the host system once I become root in LXC-guests. I tried to circumvent this problem with apparmor, rlimits etc. but was not successful, see http://sourceforge.net/mailarchive/forum.php?thread_name=CAJ75kXYapfC_ihVyshWyGQqBL_jJbLJitgOscaCt1ciNyoyokg%40mail.gmail.com&forum_name=lxc-devel
> Is there any plan for such an implementation?

You probably should try using memory.kmem.limit_in_bytes
it was made for that puropose IIRC

-- 
William
