From: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
Date: Mon, 1 Apr 2013 13:09:09 -0700
Message-ID: <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <CAAAKZwv9=NFmt6xj1KF2va1i6=UCvka0YkmdOY9JNUMHDOWpGw@mail.gmail.com> <20130401184617.GB31435@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        bh=IhEfIDXl34AhRS6JG2TFVr0Aqy6NQiZ9XprG5wyAtHw=;
        b=MJ2BM5GCuMzNFV59aaLY4v5eTz28vdBfuXzqoSbAQvXmlFjE/VWl+QjxO49TAYl1gb
         h/u9u+w1welAy7TRs3cOsUsaW0RCAw2e8yp71wEl5bXHGEfcchvVMJDTOjHc8Mecif0F
         0OEDkWxciuUhTMWFKVCCNZmwWCzftOn0tFRWygQobQfTv5Gpd5bvtW/30vUC9wB5Bbqp
         N/KkVxg0PgXeiox/vggS3VNRspqQIF6y6xlDK4H6rT3Rwu9mi/Bm4rvofBHhmZDComxa
         nrXAfRHde6c3ZzV7VtQOrpUMqmd4tqJufoJfflZVgjWXPAiAYBXdH3Njo2OVHJ0wdNNp
         waWw==
In-Reply-To: <20130401184617.GB31435-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel J Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Mon, Apr 1, 2013 at 11:46 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Apr 01, 2013 at 11:43:03AM -0700, Tim Hockin wrote:
>> A year later - what ever happened with this?  I want it more than ever
>> for Google's use.
>
> I think the conclusion was "use kmemcg instead".

Pardon my ignorance, but... what?  Use kernel memory limits as a proxy
for process/thread counts?  That sounds terrible - I hope I am
misunderstanding?  This task counter patch had several properties that
mapped very well to what we want.

Is it dead in the water?
