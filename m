From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: BUG: unable to handle kernel NULL pointer dereference
Date: Sat, 2 Jan 2016 06:54:37 -0500
Message-ID: <20160102115437.GE3660@htj.duckdns.org>
References: <20160101234028.GA1750@hudson.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0s+86YqnHNRtN4ju6lbAxs6ZS+YGirLtoF4CZv69+hE=;
        b=AkGYD5s+XC6f1Mubo0g9sSiTbEDXW5oaXfLBum1bXkTqxh0z/CPXH9RJGouNEciUqZ
         dlAGROWcJ40E8Ep/CcKxNAAiN+01Ywtc3q2O4uMfHbgJRSd6M6aV/umqzEtcoLZasH5g
         zIJ7Ty086NI1mxcKj6W/K8zkuxYH59BHQN/LbE/0QdJoNK9IpSC4hAwASE08sagrCIDS
         1O1EyCRgqvt2dkKFI72sX33AXFcEguolPxIuiwWAA9WruXzgmPShGRcVdGm4efeF58WF
         e6DD/yjAtbV2l992JeEhL/MQkmMXNXD7PLcvvTDM30cl7odvtUORHI36Ae92kANilZSe
         DRNw==
Content-Disposition: inline
In-Reply-To: <20160101234028.GA1750-ZO/ZziT/ZXRSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 01, 2016 at 03:40:28PM -0800, Jeremiah Mahler wrote:
> all,
> 
> When running the latest linux-next (20151231) two of my machines
> hang early in the boot sequence.  The initial message is for a
> NULL pointer dereference.
> 
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
> 
> And the RIP line refers to cgroup_path.
> 
>   RIP [<ffffffff810eb178>] cgroup_path+0x30/0x80
> 
> Attached are pictures of the back trace.
> 
> Let me know if I can do anything else to help.  I will investigate the
> problem further if I get a chance.

This is most likely from the recent changes from cgroup ns support.
Reverted the patchset for now as it also introduced a bisectability
issue.  Serge, can you please look into this one?

Thanks.

-- 
tejun
