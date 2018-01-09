From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting the nsdelegate mount option
Date: Tue, 9 Jan 2018 22:38:39 +0100
Message-ID: <1e1dfa55-636f-4e40-5d20-cd4dc85d92ee@gmail.com>
References: <4768da37-ba3e-7d0c-841a-1b026c558bdd@gmail.com>
 <20180109205913.GR3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=51jE82Zm2QXckWmHLPQ60ldawTZ/Aw4QXtOYFMU8KTw=;
        b=eXB0itiNiZknJ/7glUXOtCNr/yExx0Rsp7YnkWmtMpA9IAT9Dtd198pwU9+5itGHA1
         C+qmdW3msVD0IbX62fz/MY90eOW/BwMQLYtMgGO9gPfEB1pt5b5/jQ/g5hpaEPLkou1g
         IdJJ6QFhaAn6/KLzWrYc7PAN7zyNHb0oBLWhOjeXRcwZps9+TrOY0SkgSwiDAumgskfv
         JvOSEkUcNNQrDhwnocsiLun5q0F/ABUNLGL3PV6J13XIhP+M1a9Wrkgh+8Z1isut8vqZ
         NrjTr4ksce5En0HjUs0/IqlS6QwNlZROPyGfdEG8G4jcTo3If4R9atpNrgH8NtWzdxAH
         a2jg==
In-Reply-To: <20180109205913.GR3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 01/09/2018 09:59 PM, Tejun Heo wrote:
> Hello, Michael.
> 
> On Tue, Jan 09, 2018 at 12:26:28AM +0100, Michael Kerrisk (man-pages) wrote:
>> Hello Tejun,
>>
>> Here is my attempt to document dgroup v2 delegation using 'nsdelegate'.
>> Could you please take a look at the text and let me know if anything 
>> needs fixing:
> 
> It looks great.

Thanks for the review!

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
