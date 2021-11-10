From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Wed, 10 Nov 2021 19:04:36 +0100
Message-ID: <44a28cc4-f68f-6e2c-1b0a-18b6570edc5f@siemens.com>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211110111357.17617-1-felix.moessbauer@siemens.com>
 <20211110135653.GD20566@blackbody.suse.cz>
 <AM9PR10MB4869C14EAE01B87C0037BF6A89939@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
 <20211110161020.GA20101@fuller.cnet>
 <c1e94031-a179-dc72-e5ee-3f8197bea492@siemens.com>
 <20211110175201.GA51149@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211110175201.GA51149-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Moessbauer, Felix" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "guro-b10kYP2dOMg@public.gmane.org" <guro-b10kYP2dOMg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 10.11.21 18:52, Michal Koutný wrote:
> On Wed, Nov 10, 2021 at 05:15:41PM +0100, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
>> Is there pthread_attr_setcgroup_np()?
> 
> If I'm not mistaken the 'p' in pthreads stands for POSIX and cgroups are
> Linux specific so you won't find that (unless you implement that
> yourself). ¯\_(ツ)_/¯
> 

I know what it stands for :). But I don't want to re-implement pthreads
just to have a single creation-time configurable injected. Neither would
developer of standard application, e.g. libvirt for the rt-kvm special
case while most of their use cases are fine with regular pthread APIs. I
think there is also a demand for a programming model that fits into
existing ones.

Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
