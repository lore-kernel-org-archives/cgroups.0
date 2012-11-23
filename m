From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memory-cgroup bug
Date: Fri, 23 Nov 2012 11:10:34 +0100
Message-ID: <20121123101034.GG24698@dhcp22.suse.cz>
References: <20121121200207.01068046@pobox.sk>
 <20121122152441.GA9609@dhcp22.suse.cz>
 <20121122190526.390C7A28@pobox.sk>
 <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123092829.GE24698@dhcp22.suse.cz>
 <20121123104423.338C7725@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=A1e0Rx5B8Hyx3nRdSNqn3kdFKPcUcGvj2OV2t0OKrEQ=;
        b=jr3YiFysRH/mcpKf5j/L4q0q3Nf2ILcNcA+VUuQ57moWOCQSRazY9AEFoUy3tyun+r
         95G0dWX6waGSgUKwqtVMQKo2eT17lwUQond7wiSyV9W68roxN/Ha16Qhxv4+iiEUJz1C
         38HMDJ0n9cJHRDRQwERcd6aav+V8pY/rruv0aTO2CNwVglM1gXI9arViXtOrHfwTvBll
         Dgxp0e7TGJ5O2+COirDJc+G9t+u7KV9rmEcu8InDSMLB3pkYrc7McDZNEJB3InZQQTEU
         hVGZ7OQz56lRuXMa2saiEkdSza0GfzOHqonAKgGPfF0F2FC1pi0vrzKFRJnmWw3Lhcbo
         YLKA==
Content-Disposition: inline
In-Reply-To: <20121123104423.338C7725-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri 23-11-12 10:44:23, azurIt wrote:
[...]
> # gdb vmlinux 
> GNU gdb (GDB) 7.0.1-debian
> Copyright (C) 2009 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from /root/bug/dddddddd/vmlinux...(no debugging symbols found)...done.
> (gdb) disassemble mem_cgroup_handle_oom
> No symbol table is loaded.  Use the "file" command.
> 
> 
> 
> # objdump -d vmlinux | grep mem_cgroup_handle_oom
> <no output>

Hmm, strange so the function is on the stack but it has been inlined?
Doesn't make much sense to me.

> i can recompile the kernel if anything needs to be added into it.

If you could instrument mem_cgroup_handle_oom with some printks (before
we take the memcg_oom_lock, before we schedule and into
mem_cgroup_out_of_memory)
-- 
Michal Hocko
SUSE Labs
