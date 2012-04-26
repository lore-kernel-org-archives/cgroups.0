From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFD/RFC v2] event about group change
Date: Thu, 26 Apr 2012 10:09:12 +0400
Message-ID: <4F98E688.3050209@samsung.com>
References: <4F98E4E5.6020602@samsung.com> <4F98E57E.1040201@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4F98E57E.1040201-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Fix in cgroup_add_file() with tasks flag a little bit ugly, but 
cgroup_exit() with run_callbacks flag works on this way. Don't know now 
how to do it better, split funtction to register "tasks" and other files 
separately looks ugly too.

-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics
