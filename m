From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memory-cgroup bug
Date: Fri, 23 Nov 2012 08:40:23 +0100
Message-ID: <20121123074023.GA24698@dhcp22.suse.cz>
References: <20121121200207.01068046@pobox.sk>
 <20121122152441.GA9609@dhcp22.suse.cz>
 <20121122190526.390C7A28@pobox.sk>
 <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7KlYqfXw1dy1NPwRUheAjUPJSLtj1WPHABvqyF99Luc=;
        b=VOw5yyclO2BvNJzJeIbqyFGnX1IICTSI4T/vUrYmSQrnOZI7aSKj4ROkGTKs7JzQt4
         CvN+E1dFJ/4KmYqoylXXBMGnk7kcyCwwlNccywdEmDVw3MlsHu9HT0fxKCFfz97KiuZf
         UoA83BT4Esr9gA4PsQ0T+iXK5cJ1hUXqNKUiZF3/DIxgwL+7f8zdIVH1OXQK1Njjh+px
         uczfQ1/2U0a/oK0p2Sm1NHurrtfEGGNh2Qc4bvPiMImC7okzwwtZJwYF3eR6EewMkIoh
         sJdxWgDiVH7Oix84vDzjF72tqnNARzgIixLwjf154/9zHqMeObU6laK/2erwR5HJ7kCS
         2nRQ==
Content-Disposition: inline
In-Reply-To: <20121122233434.3D5E35E6-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu 22-11-12 23:34:34, azurIt wrote:
[...]
> >And finally could you post the disassembly of your version of
> >mem_cgroup_handle_oom, please?
> 
> How can i do this?

Either use gdb YOUR_VMLINUX and disassemble mem_cgroup_handle_oom or
use objdump -d YOUR_VMLINUX and copy out only mem_cgroup_handle_oom
function.
-- 
Michal Hocko
SUSE Labs
