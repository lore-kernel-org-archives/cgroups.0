From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Tue, 3 Dec 2013 20:26:02 -0500
Message-ID: <20131204012602.GZ8277@htj.dyndns.org>
References: <20131125224335.GA15481@mail.hallyn.com>
 <20131203134506.GG8277@htj.dyndns.org>
 <20131204000344.GB24968@sergelap>
 <20131204012416.GY8277@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HcwJ0U6xk0utvfOgx6gG4AZVHlCONuwt4Kf/JragB4w=;
        b=s1sfEFck4ZFLR6fNgCnhDpJxgW+IR3tEOrQ7i83IFT7fvpA7trdRNA/qi81Mx6eQCL
         lKCZuc41iNlK57EvE8/VMgl4tdSnpHKH8N4RzzBq/F5NOniDrOKhqCaby0NYl8thzGCa
         oNAi08OwH4kcb4mCJeiSbUpWFGHORmaqZSaOfhq7ZaXplxUwmF9wG+F1zM7tXUENa7l9
         aKaOhcpiGWMjEtvcgyfiv/ClLOd/FlToyq2YQ6XyPvQtmSukd22iQqQhXwCMG6yKhjtU
         qU8HxwWWooUZDItulY6Vunhosmm8Y4HYA+Yq49sa/7h+5sKYx8yMzE5fdl/PTgf9MxYF
         ZfXw==
Content-Disposition: inline
In-Reply-To: <20131204012416.GY8277-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

And can somebody please fix up lxc-devel so that it doesn't generate
"your message awaits moderator approval" notification on *each*
message?  :(

-- 
tejun
