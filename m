From: Michal Hocko <mhocko@suse.cz>
Subject: Re: memory-cgroup bug
Date: Fri, 23 Nov 2012 10:28:29 +0100
Message-ID: <20121123092829.GE24698@dhcp22.suse.cz>
References: <20121121200207.01068046@pobox.sk>
 <20121122152441.GA9609@dhcp22.suse.cz>
 <20121122190526.390C7A28@pobox.sk>
 <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=j/FZrF1DKknY5o/Da2kKJ5pBnj8DzUpEbbPjTdCMpFs=;
        b=q0WG1LVfOVPCMXRGpS6w334/BOHIRw6My994cfv3TwuTbltrckrAXFWzqTGh4u5rPT
         TKhY7dOKg5USHg5H5UYv2efMYdEWW4D5CFM/SgYCK06AOn9Ogk/CmhMrFb0bPpH5WGuq
         pb0m8YYMOGRra+dctUkGPXxDy+fC5YvYAEw4Ncfpe6tj0ULvORLOXERgZrh/21Co4j1t
         XU1ANkGpN0MHXibK3uPilDPdBghRTEvWLohiNOjjaFiyu2hBMcbkP9g7FOqapKZ763TJ
         CPdIBAJaIhh1AcS0X0ZzG2A5n5Soc/46jetSQ5P31DzBUgpmC4VjMYxW+sgFrhcNH1y+
         TNhw==
Content-Disposition: inline
In-Reply-To: <20121123102137.10D6D653@pobox.sk>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>

On Fri 23-11-12 10:21:37, azurIt wrote:
> >Either use gdb YOUR_VMLINUX and disassemble mem_cgroup_handle_oom or
> >use objdump -d YOUR_VMLINUX and copy out only mem_cgroup_handle_oom
> >function.
> If 'YOUR_VMLINUX' is supposed to be my kernel image:
> 
> # gdb vmlinuz-3.2.34-grsec-1 
> GNU gdb (GDB) 7.0.1-debian
> Copyright (C) 2009 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> "/root/bug/vmlinuz-3.2.34-grsec-1": not in executable format: File format not recognized
> 
> 
> # objdump -d vmlinuz-3.2.34-grsec-1 

You need vmlinux not vmlinuz...
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
