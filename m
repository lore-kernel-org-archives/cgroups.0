From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memory-cgroup bug
Date: Sun, 25 Nov 2012 14:02:08 +0100
Message-ID: <20121125130208.GC10623@dhcp22.suse.cz>
References: <20121122152441.GA9609@dhcp22.suse.cz>
 <20121122190526.390C7A28@pobox.sk>
 <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121123155904.490039C5@pobox.sk>
 <20121125101707.GA10623@dhcp22.suse.cz>
 <20121125133953.AD1B2F0A@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cSwHJGVQ1jmUTDwd9nWsAYWvIs220aGECBIV+I9+bOM=;
        b=WL9o986OUJSk/SdN7ro6zd+QEf8rQTqQBxpu118o0aTJiqPNED+6py9wncHgbypSgF
         EgjO1uqRe1VHc/1y5mclSmHGRSJibgIqwzJWqnVXZdqg44rD7y9k7PgNR6MTOtoH6wLD
         koG+E8T2EzKLdSqGbwDecLH3PJWyeT6mj7famL3j3f7zE/AxZtsTgddUCidBXebIhJFK
         kT4Fd30TbmcFJPaWwn+fOQdojI15HhnAmiH30uVkWNtE2qWBmDFDYCCRxdEdLYnJId4H
         sVCQ4u98ld7jyZP8XVALMahVu0vjbnNrqVLDitwbc4aWdmY4Ij9eyTLHTrlq4pAk9b92
         2Nkw==
Content-Disposition: inline
In-Reply-To: <20121125133953.AD1B2F0A-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun 25-11-12 13:39:53, azurIt wrote:
> >Inlined at the end of the email. Please note I have compile tested
> >it. It might produce a lot of output.
> 
> 
> Thank you very much, i will install it ASAP (probably this night).

Please don't. If my analysis is correct which I am almost 100% sure it
is then it would cause excessive logging. I am sorry I cannot come up
with something else in the mean time.
-- 
Michal Hocko
SUSE Labs
