From: Tejun Heo <tj@kernel.org>
Subject: Re: cgroups(7): documenting the nsdelegate mount option
Date: Tue, 9 Jan 2018 12:59:13 -0800
Message-ID: <20180109205913.GR3668920@devbig577.frc2.facebook.com>
References: <4768da37-ba3e-7d0c-841a-1b026c558bdd@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O5uW6s4wO8YTKGLB1mukUzx0IElL47E3kOk2IJqTFlU=;
        b=ge3s17mhxMAOUT/2Y5y7+ojHiZZBzTULNGF0r1v+7Mzkf13qbVDuyRN0dCaVUekECG
         yCl3Li7OCGZZADyU1Tp7daFXf9o+ovxpXCBMdvA/Ih98xP6ChOJjZZFAonf1iERPPoAb
         GpEWUlsaYKhwCkDAOT+dckXOlg3bdAHwJeKikEAtFYOHf/AEPsE3jKIaLlQdTAWjwN0j
         +Gl4AJFfDhnSlbVrxd4PdFGti1cRqzVgifGDJEbmY9kmP23t/9VTw/eX5x14UgVu9VMq
         jNeh/idbK6dFxJX0SQNShet4E2NM7zlER9if2+6MOOsun8ha23Wo7q5M8z1nbf/q+aGo
         0X5g==
Content-Disposition: inline
In-Reply-To: <4768da37-ba3e-7d0c-841a-1b026c558bdd@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, cgroups@vger.kernel.org

Hello, Michael.

On Tue, Jan 09, 2018 at 12:26:28AM +0100, Michael Kerrisk (man-pages) wrote:
> Hello Tejun,
> 
> Here is my attempt to document dgroup v2 delegation using 'nsdelegate'.
> Could you please take a look at the text and let me know if anything 
> needs fixing:

It looks great.

Thanks.

-- 
tejun
