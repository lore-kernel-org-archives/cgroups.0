From: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: A problem with memory.oom_control
Date: Tue, 15 Apr 2014 13:05:20 +0200
Message-ID: <CAJ75kXZBYrjKp3yWiRiU99xPf4abPnFBfFNhX4Spj1xfN+jzKQ@mail.gmail.com>
References: <CAGXs5wUdhEYQ-kGEPSD2A=OceZuA1tovLs04gPcRcqBPagQJCw@mail.gmail.com>
 <534C9E45.9090005@huawei.com> <CAGXs5wVPsdPFm5EssN3_MSSermVMoUtAqc9XTH_YVN+bkPKVyA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=hoNdB9eioMCVboHbQ3UhjxFaeyeoSovGq9cv21WkQKY=;
        b=hAHBhDWrM8mMv0U85InVN4tJavgJU5xy+LQVF162L+sfRONUIInLNivJDUa9tFwLTp
         mlDTpDUnfb49LpIBhuENDKxcWk/WrSkRWv2cHhaCyzZYvppA7exAmxFyPXKxzT18ThqE
         tHj4DhKc2DTptpOHUQ6zCAZD2UjCJfQJ1h17yavhDx7g0ecrrw/YPCvxsudqkPVsv0nr
         xKGkkBaFYxRh+1QXdJR1fmtFojjxs/jTpL5Hcj7bgPqgvxjA8+clZ4aht6CTTeOCdtKJ
         xE7TdWAuT8fnU8i38PdJPoejKjgsGp1RzO+TNU6u/jMOqGPUnatZaf9k5+Ru8lMsGiE+
         CHaw==
In-Reply-To: <CAGXs5wVPsdPFm5EssN3_MSSermVMoUtAqc9XTH_YVN+bkPKVyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Kevin,

On Tue, Apr 15, 2014 at 6:03 AM, Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> So it seems that use_hierarchy cannot be changed via writing to sysfs

see: https://www.kernel.org/doc/Documentation/cgroups/memory.txt section6
NOTE1: Enabling/disabling will fail if either the cgroup already has other
       cgroups created below it, or if the parent cgroup has use_hierarchy
       enabled.

Regards,
-- 
William
