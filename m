From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Sat, 21 May 2016 02:29:55 +1000
Message-ID: <573F3B83.3020206@suse.de>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
 <573F23D0.2030500@suse.de> <20160520152244.GB5632@htj.duckdns.org>
 <1463758258.8091.3.camel@HansenPartnership.com>
 <20160520160352.GC5632@htj.duckdns.org>
 <1463760550.8091.13.camel@HansenPartnership.com>
 <20160520161759.GD5632@htj.duckdns.org>
 <1463761509.8091.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463761509.8091.19.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

>>    This is stemming from the fact that an unpriv application can't
>> create its sub-cgroups without explicit delegation from the root and
>> that has always been an explicit design choice.
>> It's tied to who's responsible for cleanup afterwards and what
>> happens when the process gets migrated to a different cgroup.  The
>> latter is an important issue on v1 hierarchies because migrating
>> tasks sometimes is used as a way to control resource distribution.
>
> OK, so is the only problem cleanup?  If so, what if I proposed that a
> cgroup directory could only be created by the owner of the userns
> (which would be any old unprivileged user) iff they create a cgroup ns
> and the cgroup ns would be responsible for removing it again, so the
> cgroup subdirectory would be tied to the cgroup namespace as its holder
> and we'd use release of the cgroup to remove all the directories?

The only question I'd have is how would we deal with visibility (and 
should a "parent" cgroup namespace be able to modify things inside the 
cgroup?). And of course, how would that interact with VFS?

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
