From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Use kvfree in pidlist_free()
Date: Tue, 3 Mar 2015 08:47:54 -0500
Message-ID: <20150303134754.GE3122@htj.duckdns.org>
References: <jpgioej3tep.fsf@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NAboiy8ylqUxJOcBQ1u0s9gKUkBdiIwOlmOkK9cCgi8=;
        b=MfvENZGsG77GzaHq7sGVQlr0Bw5pDqq2jMzNlrTdizBO7msxhTF6eKS9lNc+egrNNW
         KhoMvoxGG9OYTFJjLGwrbu3QfGr9NUakh5ovC4B1h0vYMnmV8alHD5lG79n4qLkj6SwS
         tYa6H6DwBoBk8/rncBL6Zl18E+GWwczOqWMg8IA45mjVUUqUXflC+G/JtWqNBR/mhiBT
         1XigGDTWnyC26WV+1lAZZ382ggrD2vtnLEVV4wPIbpAoO1RL138CXo2YYe1OphVYvWlg
         DyDTYPE/hI5Qh1xzYZE0higMTpD74Bn4+DLIkwzymopN7Iw8AQwcg5gzAyuD8zhVBFV8
         +5fw==
Content-Disposition: inline
In-Reply-To: <jpgioej3tep.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bandan Das <bsd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 02, 2015 at 05:51:10PM -0500, Bandan Das wrote:
> 
> The wrapper already calls the appropriate free
> function, use it instead of spinning our own.
> 
> Signed-off-by: Bandan Das <bsd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.1.

Thanks.

-- 
tejun
